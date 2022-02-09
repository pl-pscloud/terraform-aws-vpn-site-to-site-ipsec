resource "random_password" "pscloud-tunnel1-password" {
  length = 16
  special = false
}

resource "random_password" "pscloud-tunnel2-password" {
  length = 16
  special = false
}

resource "aws_vpn_gateway" "pscloud-vpn-gateway" {
  count                 = var.pscloud_transit_gateway_enable == true ? 0 : 1
  vpc_id                = var.pscloud_vpc_id

  tags = {
    Name                = "${var.pscloud_company}_vpn_gateway_${var.pscloud_env}"
  }
}

resource "aws_customer_gateway" "pscloud-vpn-customer-gateway" {
  bgp_asn               = var.pscloud_customer_gateway_bgp_asn
  ip_address            = var.pscloud_customer_gateway_ip
  type                  = var.pscloud_ipsec_type
  tags = {
    Name                = "${var.pscloud_company}_customer_gateway_${var.pscloud_env}"
  }
}

resource "aws_vpn_connection" "pscloud-vpn-ipsec-connection" {
  vpn_gateway_id        = var.pscloud_transit_gateway_enable == true ? null : aws_vpn_gateway.pscloud-vpn-gateway[0].id
  transit_gateway_id    = var.pscloud_transit_gateway_enable == true ? var.pscloud_transit_gateway_id : null

  customer_gateway_id   = aws_customer_gateway.pscloud-vpn-customer-gateway.id
  type                  = var.pscloud_ipsec_type
  static_routes_only    = var.pscloud_static_routes_only
  tunnel1_inside_cidr   = var.pscloud_inside_tunnel1_cidr
  tunnel2_inside_cidr   = var.pscloud_inside_tunnel2_cidr
  tunnel1_preshared_key = random_password.pscloud-tunnel1-password.result
  tunnel2_preshared_key = random_password.pscloud-tunnel2-password.result

  tags = {
    Name                = "${var.pscloud_company}_vpn_ipsec_connection_${var.pscloud_project}_${var.pscloud_env}"
  }
}

resource "aws_vpn_connection_route" "pscloud-vpn-ipsec-routes" {
  count                   = length(var.pscloud_static_routes)

  destination_cidr_block  = var.pscloud_static_routes[count.index]
  vpn_connection_id       = aws_vpn_connection.pscloud-vpn-ipsec-connection.id
}
