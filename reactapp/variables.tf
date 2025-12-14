variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "prefix" {
  description = "Prefix for all Azure resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "prod_zip_path" {
  description = "Path to production ZIP file"
  type        = string
}

variable "canary_zip_path" {
  description = "Path to canary ZIP file"
  type        = string
}






# variable "subscription_id" {
#   description = "The Azure Subscription ID where resources will be created."
#   type        = string
# }

# variable "prefix" {
#   description = "Prefix for all resources"
#   type        = string
# }

# variable "location" {
#   description = "Azure location"
#   type        = string
# }

# variable "prod_zip_path" {
#   description = "Path to production zip"
#   type        = string
# }

# variable "staging_zip_path" {
#   description = "Path to staging zip"
#   type        = string
# }
