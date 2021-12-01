variable "display_name" {}

variable "organization_id" {}

resource "google_folder" "group_folder" {
  display_name = var.display_name
  parent       = "organizations/${var.organization_id}"
}

output "group_folder_name" {
  value = google_folder.group_folder.name
}

output "group_folder_id" {
  value = google_folder.group_folder.folder_id
}
