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
  member   = "serviceAccount:${module.project.service_account_email}"
  org_id = var.organization_id
  for_each = toset([
#    "roles/billing.projectManager",
#    "roles/billing.user", "roles/resourcemanager.projectCreator",
    "roles/iam.securityAdmin",
#    "roles/resourcemanager.folderAdmin"
  ])
  role   = each.value
#  condition {
#    expression = "resource.name.startsWith('${google_folder.group_folder.name}')"
#    title      = "Environment group admin"
#  }
}

resource "google_folder_iam_member" "admin_bindings" {
  folder = google_folder.group_folder.folder_id
  for_each = toset(["roles/billing.projectManager",
#    "roles/billing.user",
    "roles/resourcemanager.projectCreator", "roles/iam.securityAdmin", "roles/resourcemanager.folderAdmin"])
  member   = "serviceAccount:${module.project.service_account_email}"
  role   = each.value
}