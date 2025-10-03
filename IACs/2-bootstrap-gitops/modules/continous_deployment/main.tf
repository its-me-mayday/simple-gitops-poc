terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.11.0"
    }
  }
}

provider "argocd" {
  server_addr = var.argocd_server_addr
  username    = var.argocd_admin_username
  password    = var.argocd_admin_password
}