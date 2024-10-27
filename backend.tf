terraform {
  backend "s3" {
    bucket = "terraform"
    key    = "homelab/grafana"
    region = "home-lab"

    endpoints = {
      s3 = "https://minio-api.home.lan"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    use_path_style              = true
  }
}
