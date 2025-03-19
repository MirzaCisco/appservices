provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Variable declarations for the Azure credentials
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

# Create the Resource Group RG-RedSpoke in East US
resource "azurerm_resource_group" "rg" {
  name     = "RG-RedSpoke"
  location = "East US"
}

# Create a Service Plan using the new azurerm_service_plan resource
resource "azurerm_service_plan" "app_service_plan" {
  name                = "example-serviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

# Create an Azure Linux Web App using the new azurerm_linux_web_app resource
resource "azurerm_linux_web_app" "app_service" {
  name                = "example-linuxwebapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    linux_fx_version = "PYTHON|3.8"
  }
}
