locals {
  actions_environment = tomap({
    "state_bucket_name" : google_storage_bucket.state.name,
    "organization_id" : var.organization_id,
    "billing_account" : var.billing_account,
    "service_account_email" : google_service_account.default_service_account.email,
    "group_name" : var.name,
    "group_folder_id" : google_folder.group_folder.folder_id,
    "group_folder_name" : google_folder.group_folder.name,
    "group_project_id": google_project.main.project_id,
  })
}

resource "github_actions_secret" "actions_environment" {
  repository      = github_repository.live_environment_group.name
  for_each        = local.actions_environment
  secret_name     = each.key
  plaintext_value = each.value
}


