terraform {
  required_version = ">= 1.9.1"
}

module "repository" {
  source               = "./modules/repository"
  gitea_admin_username = data.external.gitea_admin_secret.result.username
  gitea_admin_password = data.external.gitea_admin_secret.result.password
}

module "continous_deployment" {
  source                = "./modules/continous_deployment"
  argocd_admin_password = data.external.argocd_admin_secret.result.password
}
