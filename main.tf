#------------------------------------------------------------------------------#
#                 Complete Infrastructure Orchestration (Zero to Hero)         #
#------------------------------------------------------------------------------#

# 1. build the VPC and Subnet for the GKE Cluster and VM
module "vpc" {
  source      = "./modules/network"
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  region      = var.region
}

#------------------------------------------------------------------------------#

# 2. create a dedicated service account for the GKE cluster
module "gke_sa" {
  source       = "./modules/service_account"
  project_id   = var.project_id
  account_id   = "kubernetes-sa"
  display_name = "GKE Service Account"
  role         = "roles/storage.objectViewer"
}

# 3. create the GKE cluster with the dedicated service account
module "cluster" {
  source                          = "./modules/gke"
  cluster_name                    = "vois-cluster"
  project_id                      = var.project_id
  network_name                    = module.vpc.vpc_name
  subnet_name                     = module.vpc.subnet_name
  region                          = var.region
  zones                           = var.zones
  machine_type                    = "e2-medium"    # Reduced to e2-medium for faster provisioning without complications
  nodes_per_zone                  = 2              # Sufficient node for initial setup to ensure speed and reliability
  boot_disk_size                  = 50             # Appropriate and fast boot disk size
  master_cidr                     = "172.16.0.0/28"
  master_authorized_networks_cidr = "0.0.0.0/0"    # Temporarily opened for seamless communication between Nodes and Control Plane
  service_account_email           = module.gke_sa.email
}

#------------------------------------------------------------------------------#

# 4. create a Google Cloud Storage bucket for the application
module "gs_bucket" {
  source             = "./modules/gs_bucket"
  resource_count     = 2
  bucket_name        = "vois-app-bucket"
  region             = var.region
  storage_class      = "STANDARD"
  versioning_enabled = false
}

#------------------------------------------------------------------------------#

# 5. create a dedicated service account for the VM
module "vm_sa" {
  source       = "./modules/service_account"
  project_id   = var.project_id
  account_id   = "test-vm-sa"
  display_name = "Test VM Service Account"
  role         = "roles/container.developer"
}

# 6. create a test VM (Bastion Host) for management and access
module "vm" {
  source                = "./modules/vm"
  depends_on            = [module.vpc, module.vm_sa] # Relying on the VPC and VM service account modules
  vm_name               = "test-vm"
  vm_type               = "e2-micro"
  vm_image              = "ubuntu-os-cloud/ubuntu-2204-lts" # Modern and secure Ubuntu image
  subnet_name           = module.vpc.subnet_name
  network_name          = module.vpc.vpc_name
  tags                  = ["test-vm"]
  zone                  = "us-east1-b" # Same region as the cluster for speed
  service_account_email = module.vm_sa.email
}