#module "project" {
#  source  = "terraform-google-modules/project-factory/google"
#  version = "~> 11.2"
#  org_id            = null
#  name              = var.name
#  random_project_id = true
#  billing_account   = var.billing_account
#  folder_id = var.group_folder_id
#  activate_apis = [
#    "cloudresourcemanager.googleapis.com",
#    "serviceusage.googleapis.com",
#    "logging.googleapis.com",
#    "cloudbilling.googleapis.com",
#    "iam.googleapis.com",
#    "admin.googleapis.com",
#    "storage-api.googleapis.com",
#    "monitoring.googleapis.com",
#    "firebase.googleapis.com"
#  ]
#}

/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
  Project random id suffix configuration
 *****************************************/
resource "random_id" "random_project_id_suffix" {
  byte_length = 2
}

/******************************************
  Locals configuration
 *****************************************/
locals {
  #  group_id          = var.manage_group ? format("group:%s", var.group_email) : ""
  #  base_project_id   = var.project_id == "" ? var.name : var.project_id
  #  project_org_id    = var.folder_id != "" ? null : var.org_id
  #  project_folder_id = var.folder_id != "" ? var.folder_id : null
  temp_project_id   = format("%s-%s", var.name, random_id.random_project_id_suffix.hex  )
  s_account_fmt     = format("serviceAccount:%s", google_service_account.default_service_account.email )
  api_s_account     = format("%s@cloudservices.gserviceaccount.com", google_project.main.number )
  #  activate_apis       = var.activate_apis
  api_s_account_fmt = format("serviceAccount:%s", local.api_s_account)
}

/*******************************************
  Project creation
 *******************************************/
resource "google_project" "main" {
  name                = var.name
  project_id          = local.temp_project_id
  #  org_id              = local.project_org_id
  folder_id           = google_folder.group_folder.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

/******************************************
  Project lien
 *****************************************/
#resource "google_resource_manager_lien" "lien" {
#  count        = var.lien ? 1 : 0
#  parent       = "projects/${google_project.main.number}"
#  restrictions = ["resourcemanager.projects.delete"]
#  origin       = "project-factory"
#  reason       = "Project Factory lien"
#}

/******************************************
  APIs configuration
 *****************************************/
locals {
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "logging.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "firebase.googleapis.com"
  ]
}
module "project_services" {
  source = "terraform-google-modules/project-factory/google//modules/project_services"

  project_id    = google_project.main.project_id
  activate_apis = local.activate_apis
  #  activate_api_identities     = var.activate_api_identities
  #  disable_services_on_destroy = var.disable_services_on_destroy
  #  disable_dependent_services  = var.disable_dependent_services
}

/******************************************
  Shared VPC configuration
 *****************************************/
#resource "time_sleep" "wait_5_seconds" {
#  count           = var.vpc_service_control_attach_enabled ? 1 : 0
#  depends_on      = [google_access_context_manager_service_perimeter_resource.service_perimeter_attachment[0], google_project_service.enable_access_context_manager[0]]
#  create_duration = "5s"
#}
#
#resource "google_compute_shared_vpc_service_project" "shared_vpc_attachment" {
#  provider = google-beta
#
#  count           = var.enable_shared_vpc_service_project ? 1 : 0
#  host_project    = var.shared_vpc
#  service_project = google_project.main.project_id
#  depends_on      = [time_sleep.wait_5_seconds[0], module.project_services]
#}

#resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
#  provider = google-beta
#
#  count      = var.enable_shared_vpc_host_project ? 1 : 0
#  project    = google_project.main.project_id
#  depends_on = [module.project_services]
#}

#resource "google_project_default_service_accounts" "default_service_accounts" {
#  count          = upper(var.default_service_account) == "KEEP" ? 0 : 1
#  action         = upper(var.default_service_account)
#  project        = google_project.main.project_id
#  restore_policy = "REVERT_AND_IGNORE_FAILURE"
#  depends_on     = [module.project_services]
#}

/******************************************
  Default Service Account configuration
 *****************************************/
resource "google_service_account" "default_service_account" {
  #  count        = var.create_project_sa ? 1 : 0
  account_id   = "project-service-account"
  display_name = "${var.display_name} Project Service Account"
  project      = google_project.main.project_id
}
#
#/**************************************************
#  Policy to operate instances in shared subnetwork
# *************************************************/
#resource "google_project_iam_member" "default_service_account_membership" {
#  count   = var.sa_role != "" && var.create_project_sa ? 1 : 0
#  project = google_project.main.project_id
#  role    = var.sa_role
#
#  member = local.s_account_fmt
#}

#/******************************************
#  Gsuite Group Role Configuration
# *****************************************/
#resource "google_project_iam_member" "gsuite_group_role" {
#  count = var.manage_group ? 1 : 0
#
#  member  = local.group_id
#  project = google_project.main.project_id
#  role    = var.group_role
#}

#/******************************************
#  Granting serviceAccountUser to group
# *****************************************/
#resource "google_service_account_iam_member" "service_account_grant_to_group" {
#  count = var.manage_group && var.create_project_sa ? 1 : 0
#
#  member = local.group_id
#  role   = "roles/iam.serviceAccountUser"
#
#  service_account_id = "projects/${google_project.main.project_id}/serviceAccounts/${google_service_account.default_service_account[0].email}"
#}

#/******************************************************************************************************************
#  compute.networkUser role granted to G Suite group, APIs Service account, and Project Service Account
# *****************************************************************************************************************/
#resource "google_project_iam_member" "controlling_group_vpc_membership" {
#  count = var.enable_shared_vpc_service_project && length(var.shared_vpc_subnets) == 0 ? local.shared_vpc_users_length : 0
#
#  project = var.shared_vpc
#  role    = "roles/compute.networkUser"
#  member  = element(local.shared_vpc_users, count.index)
#
#  depends_on = [
#    module.project_services,
#  ]
#}

/*************************************************************************************
  compute.networkUser role granted to Project Service Account on vpc subnets
 *************************************************************************************/
#resource "google_compute_subnetwork_iam_member" "service_account_role_to_vpc_subnets" {
#  provider = google-beta
#  count    = var.enable_shared_vpc_service_project && length(var.shared_vpc_subnets) > 0 && var.create_project_sa ? length(var.shared_vpc_subnets) : 0
#
#  subnetwork = element(
#  split("/", var.shared_vpc_subnets[count.index]),
#  index(
#  split("/", var.shared_vpc_subnets[count.index]),
#  "subnetworks",
#  ) + 1,
#  )
#  role = "roles/compute.networkUser"
#  region = element(
#  split("/", var.shared_vpc_subnets[count.index]),
#  index(split("/", var.shared_vpc_subnets[count.index]), "regions") + 1,
#  )
#  project = var.shared_vpc
#  member  = local.s_account_fmt
#}

/*************************************************************************************
  compute.networkUser role granted to G Suite group on vpc subnets
 *************************************************************************************/
#resource "google_compute_subnetwork_iam_member" "group_role_to_vpc_subnets" {
#  provider = google-beta
#
#  count = var.enable_shared_vpc_service_project && length(var.shared_vpc_subnets) > 0 && var.manage_group ? length(var.shared_vpc_subnets) : 0
#  subnetwork = element(
#  split("/", var.shared_vpc_subnets[count.index]),
#  index(
#  split("/", var.shared_vpc_subnets[count.index]),
#  "subnetworks",
#  ) + 1,
#  )
#  role = "roles/compute.networkUser"
#  region = element(
#  split("/", var.shared_vpc_subnets[count.index]),
#  index(split("/", var.shared_vpc_subnets[count.index]), "regions") + 1,
#  )
#  member  = local.group_id
#  project = var.shared_vpc
#}

/*************************************************************************************
  compute.networkUser role granted to APIs Service Account on vpc subnets
 *************************************************************************************/
#resource "google_compute_subnetwork_iam_member" "apis_service_account_role_to_vpc_subnets" {
#  provider = google-beta
#
#  count = var.enable_shared_vpc_service_project && length(var.shared_vpc_subnets) > 0 ? length(var.shared_vpc_subnets) : 0
#  subnetwork = element(
#  split("/", var.shared_vpc_subnets[count.index]),
#  index(
#  split("/", var.shared_vpc_subnets[count.index]),
#  "subnetworks",
#  ) + 1,
#  )
#  role = "roles/compute.networkUser"
#  region = element(
#  split("/", var.shared_vpc_subnets[count.index]),
#  index(split("/", var.shared_vpc_subnets[count.index]), "regions") + 1,
#  )
#  project = var.shared_vpc
#  member  = local.api_s_account_fmt
#
#  depends_on = [
#    module.project_services,
#  ]
#}

/***********************************************
  Usage report export (to bucket) configuration
 ***********************************************/
#resource "google_project_usage_export_bucket" "usage_report_export" {
#  count = var.usage_bucket_name != "" ? 1 : 0
#
#  project     = google_project.main.project_id
#  bucket_name = var.usage_bucket_name
#  prefix      = var.usage_bucket_prefix != "" ? var.usage_bucket_prefix : "usage-${google_project.main.project_id}"
#
#  depends_on = [
#    module.project_services,
#  ]
#}

#/***********************************************
#  Project's bucket creation
# ***********************************************/
#resource "google_storage_bucket" "project_bucket" {
#  count = local.create_bucket ? 1 : 0
#
#  name                        = local.project_bucket_name
#  project                     = var.bucket_project == local.base_project_id ? google_project.main.project_id : var.bucket_project
#  location                    = var.bucket_location
#  labels                      = var.bucket_labels
#  force_destroy               = var.bucket_force_destroy
#  uniform_bucket_level_access = var.bucket_ula
#
#  versioning {
#    enabled = var.bucket_versioning
#  }
#}

/***********************************************
  Project's bucket storage.admin granting to group
 ***********************************************/
#resource "google_storage_bucket_iam_member" "group_storage_admin_on_project_bucket" {
##  count = local.create_bucket && var.manage_group ? 1 : 0
#
#  bucket = google_storage_bucket.state.name
#  member = local.group_id
#  role   = "roles/storage.admin"
#}

/***********************************************
  Project's bucket storage.admin granting to default compute service account
 ***********************************************/
resource "google_storage_bucket_iam_member" "s_account_storage_admin_on_project_bucket" {
#  count = local.create_bucket && var.create_project_sa ? 1 : 0

  bucket = google_storage_bucket.state.name
  role   = "roles/storage.admin"
  member = local.s_account_fmt
}

/***********************************************
  Project's bucket storage.admin granting to Google APIs service account
 ***********************************************/
#resource "google_storage_bucket_iam_member" "api_s_account_storage_admin_on_project_bucket" {
#  count = local.create_bucket ? 1 : 0
#
#  bucket = google_storage_bucket.project_bucket[0].name
#  role   = "roles/storage.admin"
#  member = local.api_s_account_fmt
#
#  depends_on = [
#    module.project_services,
#  ]
#}
#
#/******************************************
#  Attachment to VPC Service Control Perimeter
# *****************************************/
#resource "google_access_context_manager_service_perimeter_resource" "service_perimeter_attachment" {
#  count          = var.vpc_service_control_attach_enabled ? 1 : 0
#  perimeter_name = var.vpc_service_control_perimeter_name
#  resource       = "projects/${google_project.main.number}"
#}
#
#/******************************************
#  Enable Access Context Manager API
# *****************************************/
#resource "google_project_service" "enable_access_context_manager" {
#  count   = var.vpc_service_control_attach_enabled ? 1 : 0
#  project = google_project.main.number
#  service = "accesscontextmanager.googleapis.com"
#}
#
#/******************************************
#  Configure default Network Service Tier
# *****************************************/
#resource "google_compute_project_default_network_tier" "default" {
#  count        = var.default_network_tier != "" ? 1 : 0
#  project      = google_project.main.number
#  network_tier = var.default_network_tier
#}