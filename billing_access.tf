resource "google_organization_iam_member" "admin_bindings" {
  member   = "serviceAccount:${module.project.service_account_email}"
  org_id = var.organization_id
  for_each = toset(["roles/billing.projectManager", "roles/billing.user", "roles/resourcemanager.projectCreator", "roles/iam.securityAdmin", "roles/resourcemanager.folderAdmin"])
  role   = each.value
}