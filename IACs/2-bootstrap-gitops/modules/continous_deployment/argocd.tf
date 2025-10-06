resource "argocd_project" "my_project" {
  metadata {
    name      = "simple-gitops-poc-project"
    namespace = "argocd"
  }

  spec {
    description = "simple project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "http://kubernetes.default.svc"
      namespace = "default"
    }
    destination {
      server    = "http://kubernetes.default.svc"
      namespace = "ms-space"
    }

    cluster_resource_blacklist {
      group = "*"
      kind  = "*"
    }
    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

}
}