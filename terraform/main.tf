#VNet with Public and Private Subnets
module "network" {
  source              = "Azure/network/azurerm"
  version             = "5.0.0"
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  subnet_prefixes = [
    "10.0.1.0/24", # Public Subnet 1
    "10.0.2.0/24", # Public Subnet 2
    "10.0.3.0/24", # Private Subnet 1
    "10.0.4.0/24"  # Private Subnet 2
  ]

  subnet_names = [
    "public-subnet-1",
    "public-subnet-2",
    "private-subnet-1",
    "private-subnet-2"
  ]

  use_for_each = true
}


#AKS Cluster
module "aks" {
  source  = "Azure/aks/azurerm"
  version = "8.0.0"

  resource_group_name = var.resource_group_name
  kubernetes_version  = "1.29.2"
  prefix              = "myaks"
  network_plugin      = "azure"

  vnet_subnet_id = module.network.vnet_subnets["private-subnet-1"]

  agents_count     = 2
  agents_size      = "Standard_DS2_v2"
  #enable_monitoring = true


  client_id     = "your-client-id"
  client_secret = "your-client-secret"


  role_based_access_control_enabled = true
}

#Public Load Balancer (App Gateway or Azure LB)
resource "azurerm_public_ip" "appgw" {
  name                = "appgw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Application Gateway definition (optional, complex) can be added here

