output "production_url" {
  value = azurerm_app_service.app.default_site_hostname
}

output "canary_url" {
  value = azurerm_app_service_slot.canary.default_site_hostname
}



