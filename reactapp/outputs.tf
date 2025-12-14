output "production_url" {
  value = azurerm_app_service.app.default_site_hostname
}

output "canary_url" {
  value = azurerm_app_service_slot.canary.default_site_hostname
}





# # output "production_url" {
# #   value       = azurerm_app_service.app.default_site_hostname
# #   description = "URL of production app"
# # }

# # output "staging_url" {
# #   value       = azurerm_app_service_slot.staging.default_site_hostname
# #   description = "URL of staging app"
# # }

# output "appservice_url" {
#   value = azurerm_app_service.app.default_site_hostname
# }

# output "staging_slot_url" {
#   value = azurerm_app_service_slot.staging.default_site_hostname
# }

# output "state_storage_account" {
#   value = azurerm_storage_account.tfstate.name
# }

# output "state_container" {
#   value = azurerm_storage_container.tfstate.name
# }
