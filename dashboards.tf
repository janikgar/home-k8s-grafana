resource "grafana_dashboard" "health_checks" {
  config_json = jsonencode(
    yamldecode(
      templatefile("dashboards/health_checks.yaml", {
        main_datasource = grafana_data_source.k8s_prom.uid
      })
    )
  )
}

resource "grafana_dashboard" "k8s_node_exporter" {
  config_json = jsonencode(
    yamldecode(
      templatefile("dashboards/k8s_node_exporter.yaml", {
        main_datasource = grafana_data_source.prometheus.uid
        k8s_datasource  = grafana_data_source.k8s_prom.uid
        swap_webhook    = var.swap_webhook
      })
    )
  )
}

resource "grafana_dashboard" "non_k8s_node_exporter" {
  config_json = jsonencode(
    yamldecode(
      templatefile("dashboards/other_node_exporter.yaml", {
        main_datasource = grafana_data_source.prometheus.uid
        swap_webhook    = var.swap_webhook
      })
    )
  )
}

resource "grafana_dashboard" "magic_smoke" {
  config_json = jsonencode(
    yamldecode(
      templatefile("dashboards/magic_smoke.yaml", {
        main_datasource = grafana_data_source.prometheus.uid
      })
    )
  )
}

resource "grafana_dashboard" "syno_nginx_logs" {
  config_json = jsonencode(
    yamldecode(
      templatefile("dashboards/syno_nginx_logs.yaml", {
        main_datasource = grafana_data_source.prometheus.uid
        loki_datasource = grafana_data_source.loki.uid
      })
    )
  )
}

resource "grafana_dashboard" "k8s_cluster" {
  config_json = jsonencode(
    yamldecode(
      templatefile("dashboards/k8s_cluster.yaml", {
        main_datasource = grafana_data_source.prometheus.uid
        k8s_datasource  = grafana_data_source.k8s_prom.uid
      })
    )
  )
}
