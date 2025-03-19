provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

variable "subscription_id" {
  description = "The Azure subscription ID."
}

variable "client_id" {
  description = "The Azure Service Principal client ID."
}

variable "client_secret" {
  description = "The Azure Service Principal client secret."
  sensitive   = true
}

variable "tenant_id" {
  description = "The Azure tenant ID."
}

# Reference the existing Resource Group "RG-RedSpoke"
data "azurerm_resource_group" "rg" {
  name = "RG-RedSpoke"
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "example-serviceplan"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "example-linuxwebapp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  # Minimal required site_config block.
  site_config {}

  # Example app settings to indicate the runtime version.
  app_settings = {
    "PYTHON_VERSION" = "3.8"
  }
}
