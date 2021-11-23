
# note this requires the terraform to be run regularly
#resource "time_rotating" "standard" {
#  rotation_days = 30
##  rotation_minutes = 5
#}
#
#resource "google_service_account_key" "key1" {
#  service_account_id = var.service_account_id
#
#  keepers = {
#    rotation_time = time_rotating.standard.rotation_rfc3339
#  }
#
#}


resource "google_service_account_key" "default_service_account_key" {
  service_account_id = var.service_account_id

}

resource "github_actions_secret" "default_service_account_key" {
  plaintext_value = google_service_account_key.default_service_account_key.private_key
  repository      = github_repository.live_environment_group.name
  secret_name     = "GCP_SA_KEY"
}

resource "github_actions_secret" "project_id" {
  plaintext_value = var.project_id
  repository      = github_repository.live_environment_group.name
  secret_name     = "GCP_PROJECT_ID"
}
