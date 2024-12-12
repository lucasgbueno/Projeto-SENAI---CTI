resource "azurerm_kubernetes_cluster" "aks-cluster" {
  depends_on          = [azurerm_virtual_network.vnet-aks]
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  dns_prefix          = var.aks_cluster_dns
  kubernetes_version  = var.aks_version

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                 = "agentpool"
    vm_size              = "Standard_B2S"
    min_count            = var.aks_node_min_size
    max_count            = var.aks_node_max_size
    node_count           = var.aks_node_desired_size
    auto_scaling_enabled = true
    max_pods             = var.aks_pods_max_size
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}