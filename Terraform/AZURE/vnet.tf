resource "azurerm_virtual_network" "vnet-aks" {
  depends_on          = [azurerm_resource_group.resource-group]
  name                = var.vnet_name
  address_space       = var.vnet_cidr
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
}

resource "azurerm_subnet" "aks_public_subnet_a" {
  name                 = var.vnet_subnet_public_a_name
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.vnet-aks.name
  address_prefixes     = var.vnet_cidr_subnet_public_a

}

resource "azurerm_subnet" "aks_public_subnet_b" {
  name                 = var.vnet_subnet_public_b_name
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.vnet-aks.name
  address_prefixes     = var.vnet_cidr_subnet_public_b
}

resource "azurerm_network_security_group" "aks-sg" {
  name                = var.vnet_security_group_name
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "KubeSphere"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30880"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "ICMP"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.vpc_aws_cidr_vpn
    destination_address_prefix = var.vnet_cidr_string
  }
}

resource "azurerm_subnet_network_security_group_association" "public1_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_public_subnet_a.id
  network_security_group_id = azurerm_network_security_group.aks-sg.id

}
resource "azurerm_subnet_network_security_group_association" "public2_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_public_subnet_b.id
  network_security_group_id = azurerm_network_security_group.aks-sg.id

}

