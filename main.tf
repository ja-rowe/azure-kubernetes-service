provider "azurerm" {
  subscription_id = var.subscription_id
  client_id = var.serviceprincipal_id
  client_secret = var.serviceprincipal_key
  tenant_id = var.tenant_id

  features {
    
  }
}

data "azurerm_kubernetes_cluster" "default" {
  depends_on          = [module.cluster] # refresh cluster state before reading
  name                = "aks-terraform"
  resource_group_name = "aks-terraform"
}


module "cluster" {
    source = "./modules/cluster"
    serviceprincipal_id = var.serviceprincipal_id
    serviceprincipal_key = var.serviceprincipal_key 
}

module "k8s" {
  source = "./modules/k8s"
  host = data.azurerm_kubernetes_cluster.default.kube_config.0.host
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  client_key = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
}