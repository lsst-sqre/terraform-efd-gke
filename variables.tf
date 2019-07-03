#
# google provider related vars
#
variable "google_project" {
  description = "google cloud project ID"
  default     = "plasma-geode-127520"
}

variable "google_region" {
  description = "google cloud region"
  default     = "us-central1"
}

variable "google_zone" {
  description = "google cloud region/zone"
  default     = "us-central1-b"
}

#
# gke-std mod passed through vars
#
variable "initial_node_count" {
  description = "number of gke nodes to start"
  default     = 3
}

variable "gke_version" {
  description = "gke master/node version"
  default     = "latest"
}

variable "machine_type" {
  description = "machine type of default gke pool nodes"
  default     = "n1-standard-2"
}

#
# efd mod passed through vars
#
variable "env_name" {
  description = "Name of deployment environment."
}

variable "deploy_name" {
  description = "Name of deployment."
  default     = "efd"
}

variable "aws_zone_id" {
  description = "route53 Hosted Zone ID to manage DNS records in."
}

variable "domain_name" {
  description = "DNS domain name to use when creating route53 records."
}

variable "dns_enable" {
  description = "create route53 dns records."
  default     = false
}

variable "dns_overwrite" {
  description = "overwrite pre-existing DNS records"
  default     = false
}

variable "brokers_disk_size" {
  description = "Disk size for the cp-kafka brokers."
  default     = "15Gi"
}

variable "zookeeper_data_dir_size" {
  description = "Size for Data dir, where ZooKeeper will store the in-memory database snapshots."
  default     = "15Gi"
}

variable "zookeeper_log_dir_size" {
  description = "Size for data log dir, which is a dedicated log device to be used, and helps avoid competition between logging and snaphots."
  default     = "15Gi"
}

resource "random_string" "grafana_admin_pass" {
  length = 20

  keepers = {
    host = "${module.gke.host}"
  }
}

#
# efd mod vars looked up in vault, by default
#
data "vault_generic_secret" "github" {
  path = "${local.vault_root}/github"
}

variable "github_user" {
  description = "GitHub username for authenticating to the GitHub API. (defaul: vault)"
  default     = ""
}

variable "github_token" {
  description = "GitHub personal access token for authenticating to the GitHub API. (defaul: vault)"
  default     = ""
}

data "vault_generic_secret" "grafana_oauth" {
  path = "${local.vault_root}/grafana_oauth"
}

variable "grafana_oauth_client_id" {
  description = "github oauth Client ID for grafana. (default: vault)"
  default     = ""
}

variable "grafana_oauth_client_secret" {
  description = "github oauth Client Secret for grafana. (default: vault)"
  default     = ""
}

variable "grafana_oauth_team_ids" {
  description = "github team id (integer value treated as string)"
  default     = "1936535"
}

data "vault_generic_secret" "influxdb_admin" {
  path = "${local.vault_root}/influxdb_admin"
}

variable "influxdb_admin_user" {
  description = "influxdb admin account name. (default: vault)"
  default     = ""
}

variable "influxdb_admin_pass" {
  description = "influxdb admin account passphrase. (default: vault)"
  default     = ""
}

data "vault_generic_secret" "influxdb_telegraf" {
  path = "${local.vault_root}/influxdb_telegraf"
}

variable "influxdb_telegraf_pass" {
  description = "InfluxDB password for the telegraf user. (default: vault)"
  default     = ""
}

data "vault_generic_secret" "prometheus_oauth" {
  path = "${local.vault_root}/prometheus_oauth"
}

variable "prometheus_oauth_client_id" {
  description = "github oauth client id. (default: vault)"
  default     = ""
}

variable "prometheus_oauth_client_secret" {
  description = "github oauth client secret. (default: vault)"
  default     = ""
}

variable "prometheus_oauth_github_org" {
  description = "limit access to prometheus dashboard to members of this org"
  default     = "lsst-sqre"
}

data "vault_generic_secret" "tls" {
  path = "${local.vault_root}/tls"
}

variable "tls_crt" {
  description = "wildcard tls certificate. (default: vault)"
  default     = ""
}

variable "tls_key" {
  description = "wildcard tls private key. (default: vault)"
  default     = ""
}

locals {
  # Name of google cloud container cluster to deploy into
  gke_cluster_name = "${var.deploy_name}-${var.env_name}"

  # remove "<env>-" prefix for production
  dns_prefix = "${replace("${var.env_name}-", "prod-", "")}"

  prometheus_k8s_namespace     = "monitoring"
  kafka_k8s_namespace          = "kafka"
  grafana_k8s_namespace        = "grafana"
  influxdb_k8s_namespace       = "influxdb"
  telegraf_k8s_namespace       = "telegraf"
  nginx_ingress_k8s_namespace  = "nginx-ingress"
  kafka_efd_apps_k8s_namespace = "kafka-efd-apps"

  grafana_admin_pass = "${random_string.grafana_admin_pass.result}"
  grafana_admin_user = "admin"

  vault_root = "secret/dm/square/${var.deploy_name}/${var.env_name}"

  github       = "${data.vault_generic_secret.github.data}"
  github_user  = "${var.github_user != "" ? var.github_user: local.github["user"]}"
  github_token = "${var.github_token != "" ? var.github_token: local.github["token"]}"

  grafana_oauth               = "${data.vault_generic_secret.grafana_oauth.data}"
  grafana_oauth_client_id     = "${var.grafana_oauth_client_id != "" ? var.grafana_oauth_client_id : local.grafana_oauth["client_id"]}"
  grafana_oauth_client_secret = "${var.grafana_oauth_client_secret != "" ? var.grafana_oauth_client_secret : local.grafana_oauth["client_secret"]}"

  influxdb_admin      = "${data.vault_generic_secret.influxdb_admin.data}"
  influxdb_admin_pass = "${var.influxdb_admin_pass != "" ? var.influxdb_admin_pass : local.influxdb_admin["pass"]}"
  influxdb_admin_user = "${var.influxdb_admin_user != "" ? var.influxdb_admin_user : local.influxdb_admin["user"]}"

  influxdb_telegraf      = "${data.vault_generic_secret.influxdb_telegraf.data}"
  influxdb_telegraf_pass = "${var.influxdb_telegraf_pass != "" ? var.influxdb_telegraf_pass : local.influxdb_telegraf["pass"]}"

  prometheus_oauth               = "${data.vault_generic_secret.prometheus_oauth.data}"
  prometheus_oauth_client_id     = "${var.prometheus_oauth_client_id != "" ? var.prometheus_oauth_client_id : local.prometheus_oauth["client_id"]}"
  prometheus_oauth_client_secret = "${var.prometheus_oauth_client_secret != "" ? var.prometheus_oauth_client_secret : local.prometheus_oauth["client_secret"]}"

  tls     = "${data.vault_generic_secret.tls.data}"
  tls_crt = "${var.tls_crt!= "" ? var.tls_crt: local.tls["crt"]}"
  tls_key = "${var.tls_key!= "" ? var.tls_key: local.tls["key"]}"
}
