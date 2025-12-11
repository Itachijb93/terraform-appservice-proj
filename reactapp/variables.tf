variable "subscription_id" {
  description = "The Azure Subscription ID where resources will be created."
  type        = string
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "prod_zip_path" {
  description = "Path to production zip"
  type        = string
}

variable "staging_zip_path" {
  description = "Path to staging zip"
  type        = string
}
