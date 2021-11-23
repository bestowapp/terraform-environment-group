resource "random_string" "project_id_suffix" {
  length  = 5
  special = false
  lower   = true
  upper   = false
  number  = false
}

resource "google_storage_bucket" "state" {
  name                        = "${module.project.project_id}-state"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = false
  project                     = module.project.project_id
  versioning {
    enabled = true
  }
}
resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.state.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.project.service_account_email}"
}
