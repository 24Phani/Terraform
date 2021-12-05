terraform {
  required_providers {
    azurerm = {
    source = "Hashicorp/azurerm"
    version = "2.86.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG" {
  name = "MyTest-RG"
  location = "eastus" 
}