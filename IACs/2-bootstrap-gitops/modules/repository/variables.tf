variable "gitea_url" {
  description = "The GiTea URL"
  type        = string
  default     = "http://127.0.0.1:3000"
}

variable "gitea_admin_username" {
  type      = string
  sensitive = true
}

variable "gitea_admin_password" {
  type      = string
  sensitive = true
}