variable "grafana_auth" {
  description = "authentication string for Grafana"
  type        = string
  sensitive   = true
}

variable "swap_webhook" {
  description = "N8n for freeing swap on nodes"
  type        = string
  sensitive   = true
}

variable "n8n_webhook" {
  description = "N8n notification webhook for Synapse"
  type        = string
  sensitive   = true
}

variable "matrix_webhook_key" {
  description = "API key for Matrix webhook"
  type        = string
  sensitive   = true
}

variable "matrix_room_id" {
  description = "Destination Room ID for Matrix webhook"
  type        = string
}
