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

variable "name_prefix" {
  type        = string
  default     = "backup"
  description = "Name prefix used to avoid conflicts with other backup vault configurations"
}

variable "location" {
  type        = string
  default     = "europe"
  description = "Location for the backups"
}

variable "time_zone" {
  type        = string
  default     = "EEST"
  description = "Time zone applied on default backup plans"
}

variable "cmek_enabled" {
  type        = bool
  default     = false
  description = "Cusomer managed encryption key enabled"
}

variable "database_instances" {
  type = list(object({
    id = string
    name = string
    encryption_key_name = optional(string)
  }))
  default = []
  description = "Cloud sql database instances to be backed up"
}
