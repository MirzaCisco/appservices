provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "azuread" {
  tenant_id     = var.tenant_id
  client_id     = var.client_id
  client_secret = var.client_secret
}

# Create a Resource Group in Central US (change as needed)
resource "azurerm_resource_group" "rg" {
  name     = "RG-RedSpoke-Central"
  location = "Central US"
}

# Create an App Service Plan (Linux)
resource "azurerm_service_plan" "app_service_plan" {
  name                = "example-serviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"
}

# Create an Azure Linux Web App
resource "azurerm_linux_web_app" "app_service" {
  name                = "example-linuxwebapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  # Minimal required site_config block
  site_config {}

  # Example app settings
  app_settings = {
    "PYTHON_VERSION" = "3.8"
  }
}

# Retrieve an Azure AD user by their UPN
data "azuread_user" "emina" {
  user_principal_name = "emina@mirzadevopsoutlook935.onmicrosoft.com"
}

# Assign a Reader role to the user at the App Service scope
resource "azurerm_role_assignment" "app_service_iam" {
  scope                = azurerm_linux_web_app.app_service.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_user.emina.object_id

  depends_on = [
    azurerm_linux_web_app.app_service
  ]
}
