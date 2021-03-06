provider "azurerm" {
  features {}
}

resource "azurerm_app_service_plan" "CloudDevPlan" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resourceGroupName
  kind                = var.kind
  reserved            = true

  sku {
    tier = "Standard"
    size = var.size
  }
}
