# Configure the Azure provider using environment variables from Terraform Cloud
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Create the Resource Group RG-RedSpoke in East US
resource "azurerm_resource_group" "rg" {
  name     = "RG-RedSpoke"
  location = "East US"
}

# Create an App Service Plan within the resource group
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

# Create an Azure App Service associated with the App Service Plan
resource "azurerm_app_service" "app_service" {
  name                = "example-appservice"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "PYTHON|3.8"
  }
}

# Variable definitions for sensitive credentials
variable "subscription_id" {
  description = "The Azure subscription ID."
}

variable "client_id" {
  description = "The Application (client) ID."
}

variable "client_secret" {
  description = "The client secret for the Azure Service Principal."
  sensitive   = true
}

variable "tenant_id" {
  description = "The Directory (tenant) ID."
}
