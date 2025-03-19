# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "example-rg"
  location = "East US"
}

# Create an App Service Plan
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create an Azure App Service
resource "azurerm_app_service" "app_service" {
  name                = "example-appservice"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "PYTHON|3.8"
  }
}

# Variables for sensitive data
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
