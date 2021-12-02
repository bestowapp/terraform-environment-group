resource "google_folder" "group_folder" {
  display_name = var.display_name
  parent       = "organizations/${var.organization_id}"
}
