#------------------------------------------------------------------------------#
#                             Custom VPC Network                               #
#------------------------------------------------------------------------------#

resource "google_compute_network" "vpc" {
  name                            = var.vpc_name
  auto_create_subnetworks         = false # Disable automatic subnet creation for better control over IP ranges
  routing_mode                    = "GLOBAL"
  delete_default_routes_on_create = false
}

#------------------------------------------------------------------------------#
#                              Subnet Configuration                            #
#------------------------------------------------------------------------------#

resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.name
  private_ip_google_access = true # Allow VMs and Pods to communicate with Google services internally without a Public IP
}


#------------------------------------------------------------------------------#
#                          Cloud Router & Cloud NAT                            #
#------------------------------------------------------------------------------#

resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  region  = var.region
  network = google_compute_network.vpc.name
}

resource "google_compute_router_nat" "nat" {
  name                                = "${var.vpc_name}-nat"
  router                              = google_compute_router.router.name
  region                              = var.region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


#------------------------------------------------------------------------------#
#                             Firewall Rules                                   #
#------------------------------------------------------------------------------#

# Allow SSH access through Google IAP only (highest level of security)
resource "google_compute_firewall" "fw_allow_ssh" {
  name    = "allow-ssh-iap"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Range of Google IAP IP addresses
}

# Allow all egress traffic (for downloading packages and updates)
resource "google_compute_firewall" "fw_allow_all_egress" {
  name      = "allow-all-egress"
  network   = google_compute_network.vpc.name
  direction = "EGRESS"

  allow {
    protocol = "all"
  }
}