/**
 * Copyright 2026 Taito United
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

resource "google_backup_dr_backup_vault" "backup_vault" {
  location          = var.location
  backup_vault_id   = "${var.name_prefix}-vault"

  encryption_config {
    kms_key_name = var.cmek_enabled ? google_kms_crypto_key.backup_cmek_key[0].id : null
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.backup_cmek_key_backupdr
  ]

  access_restriction = "WITHIN_ORGANIZATION"
  backup_retention_inheritance = "INHERIT_VAULT_RETENTION"

  force_update = "false"
  ignore_inactive_datasources = "false"
  ignore_backup_plan_references = "false"
  allow_missing = "false"

  backup_minimum_enforced_retention_duration = "259200s"

  deletion_policy   = "PREVENT"

  lifecycle {
    prevent_destroy = true
  }

}
