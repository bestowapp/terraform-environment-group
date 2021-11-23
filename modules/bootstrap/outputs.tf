# pass-thru outputs

output "billing_account" {
  value = var.billing_account
}

output "name" {
  value = var.name
}

output "organization_id" {
  value = var.organization_id
}

# module outputs

output "bucket_name" {
  value = google_storage_bucket.state.name
}

output "project_id" {
  value = module.project.project_id
}

output "service_account_email" {
  value = module.project.service_account_email
}

output "service_account_id" {
  value = module.project.service_account_id
}

