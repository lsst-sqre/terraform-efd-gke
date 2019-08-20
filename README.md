terraform efd-gke "top level" deployment
===

[![Build Status](https://travis-ci.org/lsst-sqre/terraform-efd.png)](https://travis-ci.org/lsst-sqre/terraform-efd)

Deploys an `efd` instance on top of a `gke` cluster.

Usage
---

This package is intended to be used as a "top level" deployment, rather than as
a general purpose module, and thus declares provider configuration that that
may be inappropriate in a module.

`terragrunt` configuration example:

```terraform
terragrunt = {
  terraform {
    source = "git::git@github.com:lsst-sqre/terraform-efd-gke.git//?ref=master"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_zone\_id | route53 Hosted Zone ID to manage DNS records in. | string | n/a | yes |
| brokers\_disk\_size | Disk size for the cp-kafka brokers. | string | `"15Gi"` | no |
| deploy\_name | Name of deployment. | string | `"efd"` | no |
| dns\_enable | create route53 dns records. | string | `"false"` | no |
| dns\_overwrite | overwrite pre-existing DNS records | string | `"false"` | no |
| domain\_name | DNS domain name to use when creating route53 records. | string | n/a | yes |
| env\_name | Name of deployment environment. | string | n/a | yes |
| github\_token | GitHub personal access token for authenticating to the GitHub API. (defaul: vault) | string | `""` | no |
| github\_user | GitHub username for authenticating to the GitHub API. (defaul: vault) | string | `""` | no |
| gke\_version | gke master/node version | string | `"latest"` | no |
| google\_project | google cloud project ID | string | `"plasma-geode-127520"` | no |
| google\_region | google cloud region | string | `"us-central1"` | no |
| google\_zone | google cloud region/zone | string | `"us-central1-b"` | no |
| grafana\_oauth\_client\_id | github oauth Client ID for grafana. (default: vault) | string | `""` | no |
| grafana\_oauth\_client\_secret | github oauth Client Secret for grafana. (default: vault) | string | `""` | no |
| grafana\_oauth\_team\_ids | github team id (integer value treated as string) | string | `"1936535"` | no |
| influxdb\_admin\_pass | influxdb admin account passphrase. (default: vault) | string | `""` | no |
| influxdb\_admin\_user | influxdb admin account name. (default: vault) | string | `""` | no |
| influxdb\_telegraf\_pass | InfluxDB password for the telegraf user. (default: vault) | string | `""` | no |
| initial\_node\_count | number of gke nodes to start | string | `"3"` | no |
| machine\_type | machine type of default gke pool nodes | string | `"n1-standard-2"` | no |
| prometheus\_oauth\_client\_id | github oauth client id. (default: vault) | string | `""` | no |
| prometheus\_oauth\_client\_secret | github oauth client secret. (default: vault) | string | `""` | no |
| prometheus\_oauth\_github\_org | limit access to prometheus dashboard to members of this org | string | `"lsst-sqre"` | no |
| tls\_crt | wildcard tls certificate. (default: vault) | string | `""` | no |
| tls\_key | wildcard tls private key. (default: vault) | string | `""` | no |
| zookeeper\_data\_dir\_size | Size for Data dir, where ZooKeeper will store the in-memory database snapshots. | string | `"15Gi"` | no |
| zookeeper\_log\_dir\_size | Size for data log dir, which is a dedicated log device to be used, and helps avoid competition between logging and snaphots. | string | `"15Gi"` | no |

## Outputs

| Name | Description |
|------|-------------|
| confluent\_lb0 |  |
| confluent\_lb1 |  |
| confluent\_lb2 |  |
| grafana\_admin\_pass | grafana admin user account password. |
| grafana\_admin\_user | name of the grafana admin user account. |
| grafana\_fqdn | fqdn of grafana service. |
| grafana\_url | url of grafana dashboard. |
| influxdb\_fqdn | fqdn of influxdb service. |
| nginx\_ingress\_ip |  |
| prometheus\_fqdn | fqdn of prometheus service. |
| prometheus\_url | url of prometheus dashboard. |
| registry\_fqdn | fqdn of schema registry service. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Vault Secrets
---

See [`vault.md`](./vault.md)

`helm`
---

Note that the `helm` provider is used, which requires an initialized `helm`
repo configuration.

`pre-commit` hooks
---

```bash
go get github.com/segmentio/terraform-docs
pip install --user pre-commit
pre-commit install

# manual run
pre-commit run -a
```

See Also
---

* [`terraform`](https://www.terraform.io/)
* [`terragrunt`](https://github.com/gruntwork-io/terragrunt)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs)
* [`helm`](https://docs.helm.sh/)
* [`pre-commit`](https://github.com/pre-commit/pre-commit)
* [`pre-commit-terraform`](https://github.com/antonbabenko/pre-commit-terraform)
