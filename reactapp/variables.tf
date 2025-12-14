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


