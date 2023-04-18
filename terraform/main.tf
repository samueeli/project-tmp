terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Create azure resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Create azure container registry
resource "azurerm_container_registry" "acr" {
  name                = var.registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.sku
  admin_enabled       = true

  # Build and push client image to acr
  provisioner "local-exec" {
    command = "docker build -t ${azurerm_container_registry.acr.login_server}/${var.client_app_name} ../${var.client_folder}"
  }
  provisioner "local-exec" {
    command = "docker login ${azurerm_container_registry.acr.login_server} -u ${azurerm_container_registry.acr.admin_username} -p ${azurerm_container_registry.acr.admin_password}"
  }
  provisioner "local-exec" {
    command = "docker push ${azurerm_container_registry.acr.login_server}/${var.client_app_name}"
  }

  # Build and push server image to acr
  provisioner "local-exec" {
    command = "docker build -t ${azurerm_container_registry.acr.login_server}/${var.server_app_name} ../${var.server_folder}"
  }
  provisioner "local-exec" {
    command = "docker login ${azurerm_container_registry.acr.login_server} -u ${azurerm_container_registry.acr.admin_username} -p ${azurerm_container_registry.acr.admin_password}"
  }
  provisioner "local-exec" {
    command = "docker push ${azurerm_container_registry.acr.login_server}/${var.server_app_name}"
  }
}

# Create service plan
resource "azurerm_service_plan" "sp" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = var.os_type
  sku_name            = var.service_plan_sku
}

# Create web app from client image
resource "azurerm_linux_web_app" "client_app" {
  name                = var.client_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    always_on = false
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/${var.client_app_name}"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    VITE_API_URL                        = "https://${var.server_app_name}.azurewebsites.net/api/hello"
  }

}

# Create web app from server image
resource "azurerm_linux_web_app" "server_app" {
  name                = var.server_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    always_on = false
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/${var.server_app_name}"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    FRONTEND_DOMAIN                     = "https://${var.client_app_name}.azurewebsites.net"
  }
}