
variable "billing_account" {}
output "billing_account" {
  value = var.billing_account
}

variable "environment_group_name" {}
output "environment_group_name" {
  value = var.environment_group_name
}

variable "organization_id" {}
output "organization_id" {
  value = var.organization_id
}


#variable "service_account_id" {}
#output "service_account_id" {
#  value = var.service_account_id
#}

variable "service_account_email" {}
output "service_account_email" {
  value = var.service_account_email
}

variable "state_bucket_name" {}
output "state_bucket_name" {
  value = var.state_bucket_name
}

