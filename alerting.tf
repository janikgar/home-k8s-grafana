resource "grafana_contact_point" "hass" {
  name = "HASS"
  webhook {
    url         = "http://home-assistant.home.lan:8123/api/webhook/external_alert"
    http_method = "POST"
  }
}

resource "grafana_contact_point" "hass_no_resolve" {
  name = "HASS (no resolve)"
  webhook {
    url                     = "http://home-assistant.home.lan:8123/api/webhook/external_alert"
    http_method             = "POST"
    disable_resolve_message = true
  }
}

resource "grafana_notification_policy" "root" {
  group_by      = ["alert"]
  contact_point = grafana_contact_point.hass.name

  group_wait      = "30s"
  group_interval  = "5m"
  repeat_interval = "4h"

  policy {
    matcher {
      label = "job"
      match = "="
      value = "fail2ban"
    }

    contact_point = grafana_contact_point.hass_no_resolve.name
    group_by      = ["..."]
  }
}
