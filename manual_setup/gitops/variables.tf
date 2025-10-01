variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "gitea_url" {
  type    = string
  default = "http://localhost:3000"
}

variable "gitea_token" {
  type    = string
  default = "abcd"
}

variable "gitea_username" {
  type    = string
  default = "gitea_admin"
}

variable "gitea_password" {
  type    = string
  default = "r8sA8CPHD9!bt6d"
}