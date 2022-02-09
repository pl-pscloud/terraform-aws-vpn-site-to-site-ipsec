variable "pscloud_env" {}
variable "pscloud_company" {}
variable "pscloud_project" { default = "default" }
variable "pscloud_vpc_id" {}
variable "pscloud_vpn_gateway_amazon_side_asn" { default = 64512 }
variable "pscloud_customer_gateway_bgp_asn" { default = 65000 }
variable "pscloud_customer_gateway_ip" {}

variable "pscloud_transit_gateway_enable" { default = false }
variable "pscloud_transit_gateway_id" { default = null }


variable "pscloud_inside_tunnel1_cidr" { default = "169.254.142.80/30" }
variable "pscloud_inside_tunnel2_cidr" { default = "169.254.221.92/30" }
variable "pscloud_static_routes_only"  { default = false }
variable "pscloud_static_routes" { default = [] }
variable "pscloud_ipsec_type" { default = "ipsec.1"}
