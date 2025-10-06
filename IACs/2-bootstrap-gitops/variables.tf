variable "cluster_name" {
  type    = string
  default = "simple-gitops-poc-cluster"
}

variable "gitea_namespace" {
  type    = string
  default = "gitea"
}

variable "gitea_secret_name" {
  type    = string
  default = "gitea-admin"
}
variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "argocd_secret_name" {
  type    = string
  default = "argocd-initial-admin-secret"
}

variable "gitea_url" {
  description = "The GiTea URL"
  type        = string
  default     = "http://127.0.0.1:3000"
}

variable "gitea_token" {
  type = string
}