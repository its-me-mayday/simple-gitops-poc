variable "argocd_server_addr" {
  description = "The ArgoCD URL"
  type        = string
  default     = "172.18.0.4:30081"
}

variable "argocd_admin_username" {
  type      = string
  sensitive = true
  default   = "admin"
}

variable "argocd_admin_password" {
  type      = string
  sensitive = true
}

variable "gitea_url" {
  description = "The GiTea URL"
  type        = string
}

variable "gitea_svc" {
  description = "The GiTea URL"
  type        = string
}

variable "gitea_admin_username" {
  type      = string
  sensitive = true
}

variable "gitea_token" {
  type      = string
  sensitive = true
}