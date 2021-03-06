#resource "google_organization_iam_member" "admin_bindings" {
#  member   = "serviceAccount:${module.project.service_account_email}"
#  org_id = var.organization_id
#  for_each = toset(["roles/billing.projectManager", "roles/billing.user", "roles/resourcemanager.projectCreator"])
#  role   = each.value
#  condition {
#    expression = "resource.name.startsWith('${google_folder.group_folder.name}')"
#    title      = ""
#  }
#}

#
resource "google_organization_iam_member" "admin_bindings" {
  member   = "serviceAccount:${google_service_account.default_service_account.email}"
  org_id = var.organization_id
  for_each = toset([
    "roles/iam.securityAdmin",
  ])
  role   = each.value
}

resource "google_folder_iam_member" "admin_bindings" {
  folder   = google_folder.group_folder.folder_id
  for_each = toset(["roles/billing.projectManager",
#    "roles/billing.user",
    "roles/resourcemanager.projectCreator", "roles/iam.securityAdmin", "roles/resourcemanager.folderAdmin"])
  member   = "serviceAccount:${google_service_account.default_service_account.email}"
  role   = each.value
}

resource "google_folder_iam_member" "default_service_account_environment_group_folder" {
  folder   = google_folder.group_folder.folder_id
  member   = "serviceAccount:${google_service_account.default_service_account.email}"
  for_each = toset([
    "roles/resourcemanager.folderAdmin", "roles/resourcemanager.organizationAdmin", "roles/owner",
    "roles/resourcemanager.projectCreator", "roles/resourcemanager.projectIamAdmin", "roles/billing.projectManager",
  ])
  role     = each.value
}