resource "grafana_folder" "rules" {
  title = "Alerts"
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
