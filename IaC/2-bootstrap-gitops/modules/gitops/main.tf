terraform {
  required_version = ">= 1.9.1"
  required_providers {
    gitea = {
      source  = "go-gitea/gitea"
      version = "0.7.0"
    }
    external = { source = "hashicorp/external" }
  }
}

provider "gitea" {
  base_url = var.gitea_url
  username = var.gitea_admin_username
  password = var.gitea_admin_password
  insecure = true
}

