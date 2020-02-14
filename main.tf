resource "random_password" "pscloud-tunnel1-password" {
  length = 16
  special = false
}

resource "random_password" "pscloud-tunnel2-password" {
  length = 16
  special = false
}

resource "aws_vpn_gateway" "pscloud-vpn-gateway" {
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
  vpn_gateway_id        = aws_vpn_gateway.pscloud-vpn-gateway.id
  customer_gateway_id   = aws_customer_gateway.pscloud-vpn-customer-gateway.id
  type                  = var.pscloud_ipsec_type
  static_routes_only    = true
  tunnel1_inside_cidr   = var.pscloud_inside_tunnel1_cidr
  tunnel2_inside_cidr   = var.pscloud_inside_tunnel2_cidr
  tunnel1_preshared_key = random_password.pscloud-tunnel1-password.result
  tunnel2_preshared_key = random_password.pscloud-tunnel2-password.result

  tags = {
    Name                = "${var.pscloud_company}_vpn_ipsec_connection_${var.pscloud_env}"
  }
}

resource "aws_vpn_connection_route" "pscloud-vpn-ipsec-routes" {
  count                   = length(var.pscloud_static_routes)

  destination_cidr_block  = var.pscloud_static_routes[0]
  vpn_connection_id       = aws_vpn_connection.pscloud-vpn-ipsec-connection.id
}

resource "aws_route_table" "pscloud-rt-ipsec" {
  vpc_id = var.pscloud_vpc_id

  route {
    cidr_block = var.pscloud_static_routes
    gateway_id = aws_vpn_gateway.pscloud-vpn-gateway.id
  }

  tags = {
    Name = "${var.pscloud_company}_rt_ipsec_${var.pscloud_env}"
    Project = "IPSEC"
  }
}

resource "aws_route_table_association" "pscloud-ipsec-assoc-public" {
  count                   = length(var.pscloud_subnets_ids_assoc)
  subnet_id               = element(var.pscloud_subnets_ids_assoc, count.index).id
  route_table_id          = aws_route_table.pscloud-rt-ipsec.id
}