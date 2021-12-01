module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 11.2"

  name              = var.name
  org_id            = var.organization_id
  folder_id = var.group_folder_id
  billing_account   = var.billing_account
  random_project_id = true
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