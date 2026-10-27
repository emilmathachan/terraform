provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rsg" {
  name     = "techwithemil-resources"
  location = "West Europe"
}
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = "techwithemil-network"
  resource_group_name = azurerm_resource_group.rsg.name
  location            = azurerm_resource_group.rsg.location
  address_space       = ["10.0.0.0/16"]
}
