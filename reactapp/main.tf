terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# ---------------------
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# ---------------------
# App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Windows"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# ---------------------
# Production Web App
resource "azurerm_app_service" "app" {
  name                = "${var.prefix}-webapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
}

# ---------------------
# Staging Slot
resource "azurerm_app_service_slot" "staging" {
  name                = "${var.prefix}-staging"
  app_service_name    = azurerm_app_service.app.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
}

# ---------------------
# Deploy Production ZIP
resource "null_resource" "deploy_prod" {
  triggers = {
    prod_zip_hash = filesha256(var.prod_zip_path)
  }

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_app_service.app.name} --src-path ${var.prod_zip_path} --type zip"
  }
}

# ---------------------
# Deploy Staging ZIP
resource "null_resource" "deploy_staging" {
  triggers = {
    staging_zip_hash = filesha256(var.staging_zip_path)
  }

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_app_service.app.name} --slot ${azurerm_app_service_slot.staging.name} --src-path ${var.staging_zip_path} --type zip"
  }
}

# ---------------------
# Slot Swap
resource "null_resource" "swap_slots" {
  triggers = {
    staging_zip_hash = filesha256(var.staging_zip_path)
  }

  depends_on = [
    null_resource.deploy_staging
  ]

  provisioner "local-exec" {
    command = "az webapp deployment slot swap --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_app_service.app.name} --slot ${azurerm_app_service_slot.staging.name}"
  }
}
