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

resource "azurerm_resource_group" "rg" {
  name     = "RG-RedSpoke"
  location = "East US"
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "example-serviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "example-linuxwebapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  # A minimal site_config block is required.
  site_config {}

  # Use app_settings to signal your runtime preference.
  app_settings = {
    "PYTHON_VERSION" = "3.8"
  }
}
