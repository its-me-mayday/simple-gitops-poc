resource "kind_cluster" "my_cluster" {
  name            = var.cluster_name
  wait_for_ready  = true
  node_image      = "kindest/node:v1.33.1"
  kubeconfig_path = var.kubeconfig_path

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
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

    networking {
      pod_subnet          = "192.168.0.0/16"
      ip_family           = "dual"
      disable_default_cni = true
    }
  }
}