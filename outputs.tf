output "confluent_lb0" {
  value = "${module.efd.confluent_lb0}"
}

output "confluent_lb1" {
  value = "${module.efd.confluent_lb1}"
}

output "confluent_lb2" {
  value = "${module.efd.confluent_lb2}"
}

output "nginx_ingress_ip" {
  value = "${module.efd.nginx_ingress_ip}"
}

output "grafana_fqdn" {
  description = "fqdn of grafana service."
  value       = "${module.efd.grafana_fqdn}"
}

output "grafana_url" {
  description = "url of grafana dashboard."
  value       = "https://${module.efd.grafana_fqdn}"
}

output "grafana_admin_pass" {
  description = "grafana admin user account password."
  sensitive   = true
  value       = "${local.grafana_admin_pass}"
}

output "grafana_admin_user" {
  description = "name of the grafana admin user account."
  value       = "${local.grafana_admin_user}"
}

output "prometheus_fqdn" {
  description = "fqdn of prometheus service."
  value       = "${module.efd.prometheus_fqdn}"
}

output "prometheus_url" {
  description = "url of prometheus dashboard."
  value       = "https://${module.efd.prometheus_fqdn}"
}

output "influxdb_fqdn" {
  description = "fqdn of influxdb service."
  value       = "${module.efd.influxdb_fqdn}"
}
