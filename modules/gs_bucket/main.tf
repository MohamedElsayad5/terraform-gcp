resource "google_storage_bucket" "bucket" {
  count                       = var.resource_count
  name                        = "${var.bucket_name}-${count.index}-${random_id.gs_random_id.hex}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true # Enable uniform bucket-level access for better security and simplified permissions management
  storage_class               = var.storage_class

  versioning {
    enabled = var.versioning_enabled
  }
}