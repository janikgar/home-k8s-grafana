terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "~> 1.3"
    }
  }
}

provider "grafana" {
  url    = "https://grafana.home.lan"
  auth   = var.grafana_auth

  insecure_skip_verify = true
}
