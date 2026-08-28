variable "vm_name" { type = string }
variable "vm_type" { type = string }
variable "vm_image" { type = string }
variable "zone" { type = string }
variable "tags" { type = set(string) }
variable "network_name" { type = string }
variable "subnet_name" { type = string }
variable "service_account_email" { type = string }

variable "resource_count" {
  type    = number
  default = 1
}