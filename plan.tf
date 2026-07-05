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

resource "google_backup_dr_backup_plan" "database_backup_plan" {
  location       = var.location
  backup_plan_id = "${var.name_prefix}-database-plan"
  resource_type  = "sqladmin.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.backup_vault.id

  backup_rules {
    rule_id                = "daily"
    backup_retention_days  = 30

    standard_schedule {
      recurrence_type     = "DAILY"
      time_zone           = var.time_zone

      backup_window {
        start_hour_of_day = 0
        end_hour_of_day   = 6
      }
    }
  }

  log_retention_days = 4
}

resource "google_backup_dr_backup_plan_association" "database_backup_plan" {
  for_each                   = {for item in var.database_instances: item.id => item}

  location                   = var.location
  resource_type              = "sqladmin.googleapis.com/Instance"
  backup_plan_association_id = "${var.name_prefix}-${each.value.name}-plan"
  resource                   = each.value.id
  backup_plan                = google_backup_dr_backup_plan.database_backup_plan.name
}
