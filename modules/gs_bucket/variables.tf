variable "bucket_name" { type = string }
variable "region" { type = string }
variable "storage_class" {
  type    = string
  default = "STANDARD"
}

variable "versioning_enabled" {
  type    = bool
  default = false
}

variable "resource_count" {
  type    = number
  default = 1
}