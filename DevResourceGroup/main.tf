terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.86.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscriptionID
}

resource "azurerm_resource_group" "DevRG" {
    name = var.resourceGroupname
    location = var.location

    tags = {
        environment = "Dev"
    }
}
