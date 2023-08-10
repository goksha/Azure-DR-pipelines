terraform {
  backend "azurerm" {
    resource_group_name  = "my-aks-cluster-rg"
    storage_account_name = "terraformstateshagok"
    container_name       = "terraformstate"
    key                  = "secondary.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_kubernetes_cluster" "aks_cluster_secondary" {
  name                = "my-aks-cluster-secondary"
  location            = "West US"
  resource_group_name = "my-aks-cluster-rg-secondary"
  dns_prefix          = "myaksclustersecondary"  # Change this to your desired DNS prefix for the AKS cluster

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"  # Change this to the desired VM size for the default node pool
  }
  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster_secondary.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster_secondary.kube_config_raw

  sensitive = true
}

