terraform {
  backend "s3" {
    bucket   = "terraform"
    key      = "homelab/grafana"
    region   = "home-lab"
    endpoint = "https://minio-api.home.lan"

    skip_region_validation      = true
    skip_credentials_validation = true
    force_path_style            = true
  }
}
