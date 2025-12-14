# terraform {
#   backend "azurerm" {
#     resource_group_name  = "bgapp2-tfstate-rg"
#     storage_account_name = "bgapp2tfstate"
#     container_name       = "tfstate"
#     key                  = "appservice.terraform.tfstate"
#   }
# }
