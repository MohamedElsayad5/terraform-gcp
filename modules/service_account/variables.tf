variable "account_id" {
  type        = string
  description = "Unique ID for the service account"
}

variable "display_name" {
  type        = string
  description = "Friendly name for the service account"
}

variable "role" {
  type        = string
  description = "IAM role to assign to the service account"
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
}