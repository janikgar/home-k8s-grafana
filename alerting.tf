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

resource "grafana_contact_point" "synapse" {
  name = "Synapse"
  webhook {
    url         = "https://mtx-webhook.home.lan?formatter=grafana&key=${var.matrix_webhook_key}&room_id=${var.matrix_room_id}"
    http_method = "POST"
  }
}

resource "grafana_contact_point" "n8n_synapse" {
  name = "N8n-Synapse"
  webhook {
    url         = "https://n8n.home.lan/webhook/a0650a8c-c8a1-4b6a-bead-6a5e8d78f431"
    http_method = "POST"
  }
}

resource "grafana_notification_policy" "root" {
  group_by = ["alert"]
  # contact_point = grafana_contact_point.hass.name
  contact_point = grafana_contact_point.n8n_synapse.name

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
