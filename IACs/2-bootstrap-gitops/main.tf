terraform {
  required_version = ">= 1.9.1"
}

module "repository" {
  source               = "./modules/repository"
  gitea_admin_username = data.external.gitea_admin_secret.result.username
  gitea_admin_password = data.external.gitea_admin_secret.result.password
  gitea_url            = var.gitea_url
}

module "continous_deployment" {
  source                = "./modules/continous_deployment"
  argocd_admin_password = data.external.argocd_admin_secret.result.password
  gitea_admin_username  = data.external.gitea_admin_secret.result.username
  gitea_token           = var.gitea_token
  gitea_url             = var.gitea_url
  gitea_svc             = "gitea-http.gitea.svc"
}
