# Google Cloud backup

Example usage:

```
provider "google" {
  alias               = "backup"
  project             = "my-backup"
  region              = "europe-west3"
  zone                = "europe-west3-b"
}

resource "google_project_service" "backup_backupdr" {
  provider            = google.backup
  service             = "backupdr.googleapis.com"
}

module "backup" {
  source              = "TaitoUnited/backup/google"
  version             = "1.0.0"
  depends_on          = [
    google_project_service.backup_backupdr,
  ]

  providers = {
    /* Place backups to another GCP project */
    google = google.backup
  }

  name_prefix         = "backup"
  location            = "europe-west3"
  time_zone           = "EEST"
  cmek_enabled        = true

  database_instances  = concat(module.databases.postgres_instances, module.databases.mysql_instances)
}
```

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/google)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/google)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/google)
- [Compute](https://registry.terraform.io/modules/TaitoUnited/compute/google)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/google)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/google)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/google)
- [Backup](https://registry.terraform.io/modules/TaitoUnited/backup/google)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/google)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/google)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

TIP: Similar modules are also available for AWS, Azure, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See also [Google Cloud project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/google), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
