resource "kind_cluster" "my_cluster" {
  name            = var.cluster_name
  wait_for_ready  = true
  node_image      = "kindest/node:v1.34.0"
  kubeconfig_path = var.kubeconfig_path

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }

  }
}