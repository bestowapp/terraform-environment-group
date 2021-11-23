resource "google_organization_iam_member" "billing_access" {
  member   = "serviceAccount:${var.service_account_email}"
  org_id = var.organization_id
  for_each = toset(["roles/billing.projectManager", "roles/billing.user", "roles/resourcemanager.projectCreator"])
  role   = each.value
}