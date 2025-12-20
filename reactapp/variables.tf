variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "location" {
  type        = string
  default     = "East US"
}

variable "prefix" {
  type        = string
}

variable "prod_zip_path" {
  type        = string
  description = "Path to production ZIP"
}

variable "canary_zip_path" {
  type        = string
  description = "Path to canary ZIP"
}
