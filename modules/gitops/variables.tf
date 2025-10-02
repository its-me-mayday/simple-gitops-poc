variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "gitea_url" {
  description = "The GiTea URL"
  type        = string
  default     = "http://127.0.0.1:3000"
}

variable "namespace" {
  description = "The GiTea URL"
  type        = string
  default     = "gitea"
}

variable "secret_name" {
  description = "The GiTea URL"
  type        = string
  default     = "gitea-admin"
}

variable "kubeconfig_path" {
  type = string
}
