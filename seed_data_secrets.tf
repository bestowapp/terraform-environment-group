locals {
  actions_environment = tomap({
    "bucket_name" : google_storage_bucket.state.name,
    "organization_id" : var.organization_id,
    "billing_account" : var.billing_account,
    "service_account_id" : module.project.service_account_id,
    "service_account_email" : module.project.service_account_email,
    "project_id" : module.project.project_id,
    "environment_group_name" : var.name,
    "group_folder_name" : google_folder.group_folder.name,
    "group_folder_id" : google_folder.group_folder.folder_id
  })
}

resource "github_actions_secret" "actions_environment" {
  repository      = github_repository.live_environment_group.name
  for_each        = local.actions_environment
  secret_name     = each.key
  plaintext_value = each.value
}


