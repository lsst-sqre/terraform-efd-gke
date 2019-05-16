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

provider "kubernetes" {
  version = "~> 1.6.2"

  config_path      = "${local.kubeconfig_filename}"
  load_config_file = true
}

module "gke" {
  source = "git::https://github.com/lsst-sqre/terraform-gke-std.git//?ref=2.x"

  name               = "${local.gke_cluster_name}"
  gke_version        = "${var.gke_version}"
  initial_node_count = "${var.initial_node_count}"
  machine_type       = "${var.machine_type}"
}

# write out our own copy of kubeconfig
# there does not seem to be a sane way to ignore changes in the file on disk
resource "local_file" "kubeconfig" {
  content  = "${module.gke.kubeconfig}"
  filename = "${local.kubeconfig_filename}"

  # this forces the gke cluster to be up before proceeding to the efd deployment
  depends_on = ["module.gke"]
}

module "efd_kafka" {
  source = "git::git@github.com:lsst-sqre/terraform-efd-kafka.git//?ref=master"

  # replace with data lookup?
  domain_name = "${var.domain_name}"

  # oh tf >= 0.12, take me away...
  env_name                       = "${var.env_name}"
  deploy_name                    = "${var.deploy_name}"
  aws_zone_id                    = "${var.aws_zone_id}"
  grafana_oauth_client_id        = "${var.grafana_oauth_client_id}"
  grafana_oauth_client_secret    = "${var.grafana_oauth_client_secret}"
  grafana_oauth_team_ids         = "${var.grafana_oauth_team_ids}"
  grafana_admin_user             = "${var.grafana_admin_user}"
  grafana_admin_pass             = "${var.grafana_admin_pass}"
  tls_crt_path                   = "${var.tls_crt_path}"
  tls_key_path                   = "${var.tls_key_path}"
  dns_enable                     = "${var.dns_enable}"
  influxdb_admin_user            = "${var.influxdb_admin_user}"
  influxdb_admin_pass            = "${var.influxdb_admin_pass}"
  github_user                    = "${var.github_user}"
  github_token                   = "${var.github_token}"
  brokers_disk_size              = "${var.brokers_disk_size}"
  zookeeper_data_dir_size        = "${var.zookeeper_data_dir_size}"
  zookeeper_log_dir_size         = "${var.zookeeper_log_dir_size}"
  influxdb_telegraf_pass         = "${var.influxdb_telegraf_pass}"
  prometheus_oauth_github_org    = "${var.prometheus_oauth_github_org}"
  prometheus_oauth_client_id     = "${var.prometheus_oauth_client_id}"
  prometheus_oauth_client_secret = "${var.prometheus_oauth_client_secret}"
  kubeconfig_filename            = "${local_file.kubeconfig.filename}"
}
