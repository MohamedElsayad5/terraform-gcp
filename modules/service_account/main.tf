# create a service account
resource "google_service_account" "account" {
  account_id   = var.account_id
  display_name = var.display_name
}

# Attach the role (Permission) to the service account at the project level
resource "google_project_iam_member" "iam_member" {
  role   = var.role
  member = "serviceAccount:${google_service_account.account.email}"
  
  depends_on = [
    google_service_account.account
  ]
  
  project = var.project_id
}