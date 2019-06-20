provider "template" {
  version = "~> 1.0"
}

provider "null" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.2"
}

provider "aws" {
  version = "~> 2.10.0"
  region  = "us-east-1"
}

provider "google" {
  version = "~> 2.6.0"
  project = "${var.google_project}"
  region  = "${var.google_region}"
  zone    = "${var.google_zone}"
}

module "gke" {
  source = "git::https://github.com/lsst-sqre/terraform-gke-std.git//?ref=2.x"

  name               = "${local.gke_cluster_name}"
  gke_version        = "${var.gke_version}"
  initial_node_count = "${var.initial_node_count}"
  machine_type       = "${var.machine_type}"
}

provider "kubernetes" {
  version = "~> 1.7.0"

  load_config_file       = false
  host                   = "${module.gke.host}"
  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
  token                  = "${module.gke.token}"
}

module "tiller" {
  source = "git::https://github.com/lsst-sqre/terraform-tinfoil-tiller.git?ref=0.9.x"

  namespace = "kube-system"
}

provider "helm" {
  version = "~> 0.9.1"

  service_account = "${module.tiller.service_account}"
  namespace       = "${module.tiller.namespace}"
  install_tiller  = false

  kubernetes {
    load_config_file       = false
    host                   = "${module.gke.host}"
    cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
    token                  = "${module.gke.token}"
  }
}

module "efd" {
  source = "git::https://github.com/lsst-sqre/terraform-efd.git//?ref=7be4e5276a318a15b7a514d3b00bde5739a58ace"

  # replace with data lookup?
  domain_name = "${var.domain_name}"

  # oh tf >= 0.12, take me away...
  aws_zone_id                    = "${var.aws_zone_id}"
  brokers_disk_size              = "${var.brokers_disk_size}"
  deploy_name                    = "${var.deploy_name}"
  dns_enable                     = "${var.dns_enable}"
  dns_overwrite                  = "${var.dns_overwrite}"
  env_name                       = "${var.env_name}"
  github_token                   = "${var.github_token}"
  github_user                    = "${var.github_user}"
  grafana_admin_pass             = "${var.grafana_admin_pass}"
  grafana_admin_user             = "${var.grafana_admin_user}"
  grafana_oauth_client_id        = "${var.grafana_oauth_client_id}"
  grafana_oauth_client_secret    = "${var.grafana_oauth_client_secret}"
  grafana_oauth_team_ids         = "${var.grafana_oauth_team_ids}"
  influxdb_admin_pass            = "${var.influxdb_admin_pass}"
  influxdb_admin_user            = "${var.influxdb_admin_user}"
  influxdb_telegraf_pass         = "${var.influxdb_telegraf_pass}"
  prometheus_oauth_client_id     = "${var.prometheus_oauth_client_id}"
  prometheus_oauth_client_secret = "${var.prometheus_oauth_client_secret}"
  prometheus_oauth_github_org    = "${var.prometheus_oauth_github_org}"
  tls_crt_path                   = "${var.tls_crt_path}"
  tls_key_path                   = "${var.tls_key_path}"
  zookeeper_data_dir_size        = "${var.zookeeper_data_dir_size}"
  zookeeper_log_dir_size         = "${var.zookeeper_log_dir_size}"
}
