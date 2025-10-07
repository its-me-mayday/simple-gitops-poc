resource "argocd_project" "dev_project" {
  metadata {
    name      = "dev-project"
    namespace = "argocd"
  }

  spec {
    description = "DEV simple project"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "dev"
    }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_project" "staging_project" {
  metadata {
    name      = "staging-project"
    namespace = "argocd"
  }

  spec {
    description = "STAGING simple project"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "staging"
    }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_project" "prod_project" {
  metadata {
    name      = "prod-project"
    namespace = "argocd"
  }

  spec {
    description = "PROD simple project"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "prod"
    }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_project" "shared_infra_project" {
  metadata {
    name      = "shared-infra"
    namespace = "argocd"
  }

  spec {
    description = "SHARED INFRA simple project"

    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "shared-infra"
    }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}