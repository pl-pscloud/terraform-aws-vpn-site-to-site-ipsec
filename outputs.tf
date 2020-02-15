output "pscloud_vpn_ipsec_adressess" {
  value = [
    join(" - ", [aws_vpn_connection.pscloud-vpn-ipsec-connection.tunnel1_address], [random_password.pscloud-tunnel1-password.result]),
    join(" - ", [aws_vpn_connection.pscloud-vpn-ipsec-connection.tunnel2_address], [random_password.pscloud-tunnel2-password.result]),
  ]
}

output "pscloud_tunnel1_address" {
  value = aws_vpn_connection.pscloud-vpn-ipsec-connection.tunnel1_address
}

output "pscloud_tunnel2_address" {
  value = aws_vpn_connection.pscloud-vpn-ipsec-connection.tunnel2_address
}

output "pscloud_tunnel1_prekey" {
  value = random_password.pscloud-tunnel1-password.result
}

output "pscloud_tunnel2_prekey" {
  value = random_password.pscloud-tunnel2-password.result
}

output "pscloud_vpgw_id" {
  value = aws_vpn_gateway.pscloud-vpn-gateway.id
}