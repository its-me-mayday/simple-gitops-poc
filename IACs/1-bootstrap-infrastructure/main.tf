terraform {
  required_version = ">= 1.9.1"
}

module "infrastructure" {
  source          = "./modules/infrastructure"
  cluster_name    = var.cluster_name
  kubeconfig_path = local.k8s_config_path
}