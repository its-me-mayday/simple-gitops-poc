variable "gitea_url" {
  description = "The GiTea URL"
  type        = string
}

variable "gitea_admin_username" {
  type      = string
  sensitive = true
}

variable "gitea_admin_password" {
  type      = string
  sensitive = true
}