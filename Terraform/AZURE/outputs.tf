output "azure_vpn_gateway_ip_address" {
  value = azurerm_public_ip.vpn_gateway_ip.ip_address
}