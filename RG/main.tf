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
}

resource "azurerm_resource_group" "RG" {
  name = "MyTerraform-RG"
  location = "eastus"
}

resource "azurerm_network_security_group" "DevNet" {
    name = "MyNSG"
    location = "eastus"
    resource_group_name = "MyTerraform-RG"
}

resource "azurerm_network_security_rule" "Port80" {
  name                        = "Allow80"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "MyTerraform-RG"
  network_security_group_name = azurerm_network_security_group.DevNet.name
}

resource "azurerm_virtual_network" "vNetDevNet" {
  name                = "vNetDevNet"
  location            = "eastus"
  resource_group_name = "MyTerraform-RG"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "DevNet-Sub" {
  name                 = "DevSNet"
  resource_group_name  = "MyTerraform-RG"
  virtual_network_name = azurerm_virtual_network.vNetDevNet.name
  address_prefixes = ["10.0.1.0/24"]
}