data "azurerm_resource_group" "existing" {
  name = "RG-AKS-CTI"
}

resource "azurerm_subnet" "vpn_gateway_subnet_a" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.existing.name
  virtual_network_name = azurerm_virtual_network.vnet-aks.name
  address_prefixes     = var.vnet_cidr_subnet_gateway_vpn
}

# Criação do IP público estático para o VPN Gateway
resource "azurerm_public_ip" "vpn_gateway_ip" {
  name                = "vpn-gateway-ip"
  location            = data.azurerm_resource_group.existing.location # Escolha a região adequada
  resource_group_name = data.azurerm_resource_group.existing.name     # Nome do seu grupo de recursos
  allocation_method   = "Static"
  sku                 = "Standard" # Necessário para VPN Gateway
}

# Criação do Gateway de Rede Virtual (VPN Gateway)
resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "VPN-VPG"
  location            = "East US"                         # Escolha a região adequada
  resource_group_name = data.azurerm_resource_group.existing.name # Nome do seu grupo de recursos
  type                = "Vpn"                             # Tipo de Gateway: VPN
  sku                 = "VpnGw1"                          # SKU do Gateway: VpnGw1
  active_active       = false
  enable_bgp          = false
  ip_configuration {
    name                          = "VPN-Gateway-IP-Config"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpn_gateway_subnet_a.id
  }
}

resource "azurerm_route_table" "Rota_AWS" {
  name                = "tabela_vpn"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  route {
    name           = "route1"
    address_prefix = var.vpc_cidr_subnet_public_a_vpn
    next_hop_type  = "VirtualNetworkGateway"
  }
  route {
    name           = "route2"
    address_prefix = var.vpc_cidr_subnet_public_b_vpn
    next_hop_type  = "VirtualNetworkGateway"
  }
}

resource "azurerm_subnet_route_table_association" "Associacao_tabela_1" {
  subnet_id      = azurerm_subnet.aks_public_subnet_a.id
  route_table_id = azurerm_route_table.Rota_AWS.id
}
resource "azurerm_subnet_route_table_association" "Associacao_tabela_2" {
  subnet_id      = azurerm_subnet.aks_public_subnet_b.id
  route_table_id = azurerm_route_table.Rota_AWS.id
}


resource "azurerm_local_network_gateway" "GTW-LOCAL01" {
  name                = "GTW-LOCAL01"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  gateway_address = var.tunnel1_address_aws
  address_space = [
    var.vpc_cidr_subnet_public_a_vpn,
    var.vpc_cidr_subnet_public_b_vpn
  ]
}

resource "azurerm_local_network_gateway" "GTW-LOCAL02" {
  name                = "GTW-LOCAL02"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name

  gateway_address = var.tunnel2_address_aws
  address_space = [
    var.vpc_cidr_subnet_public_a_vpn,
    var.vpc_cidr_subnet_public_b_vpn
  ]
}

resource "azurerm_virtual_network_gateway_connection" "CONEXAO-01" {
  name                       = "CONEXAO-01"
  location                   = data.azurerm_resource_group.existing.location
  resource_group_name        = data.azurerm_resource_group.existing.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.GTW-LOCAL01.id
  # AWS VPN Connection secret shared key
  shared_key = var.tunnel1_preshared_key_aws
}


resource "azurerm_virtual_network_gateway_connection" "CONEXAO-02" {
  name                       = "CONEXAO-02"
  location                   = data.azurerm_resource_group.existing.location
  resource_group_name        = data.azurerm_resource_group.existing.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.GTW-LOCAL02.id
  # AWS VPN Connection secret shared key
  shared_key = var.tunnel2_preshared_key_aws
}