output "production_url" {
  value = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "canary_url" {
  value = "https://${azurerm_linux_web_app_slot.canary.default_hostname}"
}

