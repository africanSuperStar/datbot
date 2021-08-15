resource "google_service_account" "vmaccess" {
  project = var.project_id
  account_id = "vmaccess"
  display_name = "DATBOT Sentiment Analysis VM access"
}

resource "google_project_iam_member" "bigtable_role" {
  project = var.project_id
  role = "roles/bigtable.admin"
  member = "serviceAccount:${google_service_account.vmaccess.email}"
}

resource "google_project_iam_member" "dataflow_role" {
  project = var.project_id
  role = "roles/dataflow.admin"
  member = "serviceAccount:${google_service_account.vmaccess.email}"
}

resource "google_project_iam_member" "storage_role" {
  project = var.project_id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.vmaccess.email}"
}

resource "google_project_iam_member" "compute_role" {
  project = var.project_id
  role = "roles/compute.admin"
  member = "serviceAccount:${google_service_account.vmaccess.email}"
}

output "vmaccess_service_account" {
  value = google_service_account.vmaccess.email
}