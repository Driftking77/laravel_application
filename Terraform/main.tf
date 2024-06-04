resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group
  location = var.location
}
resource "azurerm_kubernetes_cluster" "aks" {
 name                = "aks1"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "aks1"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
 identity {
    type = "SystemAssigned"
  }
  tags = {
    Environment = "Devloyment"
  }
}

