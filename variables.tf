variable "project_id" {
  type    = string
  default = "terraform-gcp-506723"
}

variable "region" {
  type    = string
  default = "us-east1" # غيرناها من us-central1 لتجنب نقص الموارد (Stockout)
}

variable "zones" {
  type    = list(string)
  default = ["us-east1-b"] # منطقة جديدة ومستقرة تماماً
}

variable "vpc_name" {
  type    = string
  default = "vois-network"
}

variable "subnet_name" {
  type    = string
  default = "vois-subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}