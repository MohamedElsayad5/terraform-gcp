#------------------------------------------------------------------------------#
#                              GKE Node Pools                                  #
#------------------------------------------------------------------------------#

resource "google_container_node_pool" "node_pool" {
  name           = "${var.cluster_name}-node-pool"
  cluster        = google_container_cluster.cluster.id
  node_locations = var.zones
  node_count     = var.nodes_per_zone

  max_pods_per_node = 110

  management {
    auto_repair  = true  # Enable automatic repair of failed nodes
    auto_upgrade = true # Enable automatic upgrade of node images
  }

  node_config {
    disk_type    = "pd-standard"
    preemptible  = false 
    machine_type = var.machine_type
    disk_size_gb = var.boot_disk_size
    image_type   = "COS_CONTAINERD" #   container-optimized OS with containerd runtime for better performance and security

    service_account = var.service_account_email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      cluster = google_container_cluster.cluster.name
    }
  }

  depends_on = [
    google_container_cluster.cluster
  ]
}