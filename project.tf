module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 11.2"
  org_id            = null
  name              = var.name
  random_project_id = true
  billing_account   = var.billing_account
  folder_id = var.group_folder_id
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "logging.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "firebase.googleapis.com"
  ]
}