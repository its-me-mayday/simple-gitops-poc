terraform {
  required_version = ">= 1.3.0"
}

module "cluster" {
  source          = "./modules/cluster"
  cluster_name    = var.cluster_name
  kubeconfig_path = local.k8s_config_path
}