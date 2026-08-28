#------------------------------------------------------------------------------#
#                          GKE Private Cluster Setup                           #
#------------------------------------------------------------------------------#

resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.zones[0]

  #remove_default_node_pool = true to ensure we create a custom node pool with our desired configuration
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_name
  subnetwork = var.subnet_name

  # Enable the Kubernetes Dashboard and other GCP services for logging and monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Use VPC-Native for performance and proper integration with the subnet
  networking_mode = "VPC_NATIVE"

  addons_config {
    http_load_balancing {
      disabled = false # Ensure the Ingress Controller is running for proper Routing
    }
    horizontal_pod_autoscaling {
      disabled = false # Enable HPA to automatically scale Pods based on load
    }
  }

  release_channel {
    channel = "STABLE" # Ensure stability of Kubernetes versions
  }

  # Enable Workload Identity to securely connect K8s permissions to GCP IAM
  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.project_id)
  }

  # Allocate IP ranges for Pods and Services within the cluster
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.pods_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

# allowing access to the control plane from all IPs (this is temporary and should be restricted in production)
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Allow-All-Control-Plane-Access"
    }
  }

  # Make the cluster private (Private Cluster)
  private_cluster_config {
    enable_private_endpoint = false 
    enable_private_nodes    = true   
    master_ipv4_cidr_block  = var.master_cidr
  }
}