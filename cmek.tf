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

resource "google_project_service_identity" "backupdr" {
  provider = google-beta
  service  = "backupdr.googleapis.com"
}

resource "google_kms_key_ring" "backup_cmek" {
  count    = var.cmek_enabled ? 1 : 0

  provider = google-beta
  name     = "${var.name_prefix}-cmek-ring"
  location = var.location

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "backup_cmek_key" {
  count    = var.cmek_enabled ? 1 : 0

  provider = google-beta
  name     = "${var.name_prefix}-cmek-key"
  key_ring = google_kms_key_ring.backup_cmek[0].id
  purpose  = "ENCRYPT_DECRYPT"

  rotation_period = "7776000s" # 90 days

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_binding" "backup_cmek_key_backupdr" {
  count    = var.cmek_enabled ? 1 : 0

  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.backup_cmek_key[0].id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    google_project_service_identity.backupdr.member,
  ]
}

/* Backup service account requires also decrypter role for CMEK key of each database */
resource "google_kms_crypto_key_iam_binding" "database_cmek" {
  for_each = {for name in local.database_cmek_key_names: name => name}

  provider      = google-beta
  crypto_key_id = each.key
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    google_project_service_identity.backupdr.member,
  ]
}
