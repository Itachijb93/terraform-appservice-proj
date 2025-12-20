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

# -------------------------
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# -------------------------
# App Service Plan (LINUX)
resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

# -------------------------
# Production Web App (LINUX)
resource "azurerm_linux_web_app" "app" {
  name                = "${var.prefix}-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
  }
}

# -------------------------
# Canary Slot
resource "azurerm_linux_web_app_slot" "canary" {
  name           = "canary"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    always_on = true
  }
}

# -------------------------
# Deploy Production ZIP
resource "null_resource" "deploy_prod" {
  triggers = {
    prod_zip_hash = filesha256(var.prod_zip_path)
  }

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_linux_web_app.app.name} --src-path ${var.prod_zip_path} --type zip"
  }
}

# -------------------------
# Deploy Canary ZIP
resource "null_resource" "deploy_canary" {
  triggers = {
    canary_zip_hash = filesha256(var.canary_zip_path)
  }

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_linux_web_app.app.name} --slot ${azurerm_linux_web_app_slot.canary.name} --src-path ${var.canary_zip_path} --type zip"
  }
}

# -------------------------
# Route 10% Traffic to Canary
resource "null_resource" "canary_traffic" {
  depends_on = [null_resource.deploy_canary]

  provisioner "local-exec" {
    command = "az webapp traffic-routing set --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_linux_web_app.app.name} --distribution canary=10"
  }
}
