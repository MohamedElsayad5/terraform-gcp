resource "google_compute_instance" "vm" {
  count        = var.resource_count
  name         = "${var.vm_name}-${count.index}"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = var.tags

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
    access_config {
      // ephemeral IP will be assigned by default, no need to specify anything here
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  labels = {
    "name" = "${var.vm_name}-${count.index}"
  }
}