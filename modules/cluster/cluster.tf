resource "azurerm_resource_group" "aks-terraform-group" {
  name = "aks-terraform"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks-terraform" {
  name = "aks-terraform"
  location = azurerm_resource_group.aks-terraform-group.location
  resource_group_name = azurerm_resource_group.aks-terraform-group.name
  dns_prefix = "aks-terraform"

  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_E2_v3"
  }

  service_principal {
    client_id = var.serviceprincipal_id
    client_secret = var.serviceprincipal_key
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
  }

}