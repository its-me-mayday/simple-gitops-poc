variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "gitea_url" {
  type    = string
}

variable "gitea_username" {
  type    = string
  sensitive = true
}

variable "gitea_password" {
  type    = string
  sensitive = true
}