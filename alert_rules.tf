resource "grafana_folder" "rules" {
  title = "Alerts"
}

resource "grafana_rule_group" "swap" {
  name             = "infra"
  folder_uid       = grafana_folder.rules.uid
  interval_seconds = 60
  org_id           = 1

  rule {
    name           = "Swap Usage High"
    for            = "5m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    labels = {
      "severity" = "warning"
    }
    annotations = {
      "description" = <<EOF
        High Swap on {{ slice $labels.instance 0 13 }}
        EOF
      "summary"     = <<EOF
        Swap usage is high on {{ slice $labels.instance 0 13 }} and needs should be cleared to reduce CPU load from high IOWait
        EOF
    }
    data {
      ref_id         = "A"
      datasource_uid = grafana_data_source.prometheus.uid

      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        refId         = "A"
        expr          = "(node_memory_SwapTotal_bytes{job=\"k8s_node\"} - node_memory_SwapFree_bytes{job=\"k8s_node\"}) / node_memory_SwapTotal_bytes{job=\"k8s_node\"}"
        hide          = false
        intervalMs    = 1000
        maxDataPoints = 43200
      })
    }
    data {
      ref_id         = "B"
      datasource_uid = "-100"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        refId         = "B"
        expression    = "A"
        type          = "reduce"
        reducer       = "last"
        hide          = false
        intervalMs    = 1000
        maxDataPoints = 43200
        datasource = {
          name = "Expression"
          type = "__expr__"
          uid  = "__expr__"
        }
        conditions = <<EOF
          [{"evaluator": {
              "params": [],
              "type": "gt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "B"
              ]
            },
            "reducer": {
              "params": [],
              "type": "last"
            },
            "type": "query"
          }]
          EOF
      })
    }
    data {
      ref_id         = "C"
      datasource_uid = "-100"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        refId         = "C"
        expression    = "B"
        type          = "threshold"
        hide          = false
        intervalMs    = 1000
        maxDataPoints = 43200
        datasource = {
          name = "Expression"
          type = "__expr__"
          uid  = "__expr__"
        }
        conditions = [
          {
            evaluator = {
              params = [0.2]
              type   = "gt"
            }
          }
        ]
      })
    }
  }
}

resource "grafana_rule_group" "fail2ban" {
  name             = "f2b"
  folder_uid       = grafana_folder.rules.uid
  interval_seconds = 60
  org_id           = 1

  rule {
    name           = "Fail2Ban Banned"
    for            = "5m"
    condition      = "B"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    labels = {
      "severity" = "info"
    }
    annotations = {
      "description" = "IP banned by {{ $labels.jail }}"
      "summary"     = "IP banned by {{ $labels.jail }}"
    }
    data {
      ref_id         = "A"
      datasource_uid = grafana_data_source.prometheus.uid

      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        refId         = "A"
        expr          = "increase(f2b_jail_banned_total{}[$__rate_interval])"
        hide          = false
        intervalMs    = 1000
        maxDataPoints = 43200
      })
    }
    data {
      ref_id         = "B"
      datasource_uid = "-100"

      relative_time_range {
        from = 0
        to   = 0
      }

      model = jsonencode({
        expression = "A"
        conditions = [
          {
            evaluator = {
              type   = "gt"
              params = [0, 0]
            }
            operator = {
              type = "and"
            }
            reducer = {
              type   = "avg"
              params = []
            }
            query = {
              params = []
            }
            type = "query"
          }
        ]
        datasource = {
          name = "Expression"
          type = "__expr__"
          uid  = "__expr__"
        }
        hide          = false
        intervalMs    = 1000
        maxDataPoints = 43200
        reducer       = "max"
        refId         = "B"
        type          = "reduce"
      })
    }
  }
}
