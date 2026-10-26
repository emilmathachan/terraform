provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rsg" {
  name     = "techwithemil-resources"
  location = "West Europe"
}
