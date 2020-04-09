/**
 * Copyright 2019 Google LLC
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
  Provider configuration
 *****************************************/
provider "google" {
  version = "~> 3.3"
}

provider "google-beta" {
  version = "~> 3.3"
}

/******************************************
  Module custom_role call
 *****************************************/
module "custom-role-project" {
  source = "../../modules/custom_role_iam/"

  target_level = "project"
  target_id    = var.project_id
  role_id      = "iamDeleter"
  permissions  = ["iam.roles.list", "iam.roles.delete"]
  description  = "This is a project level custom role."
}

/******************************************
  Create service accounts to use as members
 *****************************************/
resource "google_service_account" "custom_role_account_01" {
  account_id = "custom-role-account-01"
  project    = var.project_id
}

/******************************************
  Assigning custom_role to member
 *****************************************/
resource "google_project_iam_member" "custom_role_member" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/${module.custom-role-project.custom_role_id}"
  member  = "serviceAccount:custom-role-account-01@${var.project_id}.iam.gserviceaccount.com"
}
