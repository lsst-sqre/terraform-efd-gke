vault setup
===

Secret root path is:

    "secret/dm/square/${var.deploy_name}/${var.env_name}/<secret>"

k8s deployment secrets
---

Required secrets are:

* `github`
  * `token`
  * `user`
* `grafana_oauth`
  Example github callback url `https://${ENV_NAME}-grafana-${DEPLOY_NAME}.lsst.codes/login/github`
  * `client_id`
  * `client_secret`
* `influxdb_admin`
  * `pass`
  * `user`
* `influxdb_telegraf`
  * `pass`
* `prometheus_oauth`
  Example github callback url `https://${ENV_NAME}-prometheus-${DEPLOY_NAME}.codes/oauth2`
  * `client_id`
  * `client_secret`
* `tls`
  * `crt`
  * `key`

```bash
export ENV_NAME=prod
export DEPLOY_NAME=efd

echo "grafana oauth2 callback url is https://${ENV_NAME}-grafana-${DEPLOY_NAME}.lsst.codes/login/github"
echo "prometheus oauth2 callback url https://${ENV_NAME}-prometheus-${DEPLOY_NAME}.codes/oauth2"

vault kv put secret/dm/square/${DEPLOY_NAME}/${ENV_NAME}/grafana_oauth client_id= client_secret=

vault kv put secret/dm/square/${DEPLOY_NAME}/${ENV_NAME}/influxdb_admin pass= user=

vault kv put secret/dm/square/${DEPLOY_NAME}/${ENV_NAME}/influxdb_telegraf pass=

vault kv put secret/dm/square/${DEPLOY_NAME}/${ENV_NAME}/prometheus_oauth client_id= client_secret=

vault kv put secret/dm/square/${DEPLOY_NAME}/${ENV_NAME}/tls crt=@/home/jhoblitt/github/terragrunt-live-test/lsst-certs/lsst.codes/2018/lsst.codes_chain.pem key=@/home/jhoblitt/github/terragrunt-live-test/lsst-certs/lsst.codes/2018/lsst.codes.key
```
