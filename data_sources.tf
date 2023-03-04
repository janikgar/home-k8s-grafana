resource "grafana_data_source" "prometheus" {
  name = "Prometheus"
  type = "prometheus"
  url  = "http://192.168.1.28:30001"

  is_default = true
}

resource "grafana_data_source" "k8s_prom" {
  name = "K8s-Prom"
  type = "prometheus"
  url  = "https://prometheus.home.lan"

  json_data_encoded = jsonencode({
    httpMethod    = "POST"
    tlsSkipVerify = true
  })
}

resource "grafana_data_source" "loki" {
  name = "Loki"
  type = "loki"
  url  = "http://192.168.1.28:30002"
}