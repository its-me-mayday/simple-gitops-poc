output "cluster_info" {
  value = {
    path         = local.k8s_config_path
    cluster_name = var.cluster_name
  }
}