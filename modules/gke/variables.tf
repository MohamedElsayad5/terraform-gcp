variable "project_id" { type = string }
variable "network_name" { type = string }
variable "subnet_name" { type = string }
variable "cluster_name" { type = string }
variable "region" { type = string }
variable "zones" { type = list(string) }
variable "machine_type" { type = string }
variable "nodes_per_zone" { type = number }
variable "boot_disk_size" { type = number }
variable "service_account_email" { type = string }
variable "master_authorized_networks_cidr" { type = string }
variable "master_cidr" { type = string }

variable "pods_ipv4_cidr_block" {
  type    = string
  default = "10.48.0.0/14"
}

variable "services_ipv4_cidr_block" {
  type    = string
  default = "10.52.0.0/20"
}
