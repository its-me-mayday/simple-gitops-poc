resource "argocd_project" "dev_project" {
  metadata {
    name      = "dev-project"
    namespace = "argocd"
  }

  spec {
    description = "DEV simple project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "dev"
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

resource "argocd_project" "staging_project" {
  metadata {
    name      = "staging-project"
    namespace = "argocd"
  }

  spec {
    description = "STAGING simple project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "staging"
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

resource "argocd_project" "prod_project" {
  metadata {
    name      = "prod-project"
    namespace = "argocd"
  }

  spec {
    description = "PROD simple project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "prod"
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

resource "argocd_repository" "dev_cluster" {
  repo     = "http://${var.gitea_svc}:3000/simple-gitops-poc/dev-cluster.git"
  username = var.gitea_admin_username
  password = var.gitea_token
  name     = "Repository Secret for dev cluster"
  insecure = true
}

resource "argocd_repository" "staging_cluster" {
  repo     = "http://${var.gitea_svc}:3000/simple-gitops-poc/staging-cluster.git"
  username = var.gitea_admin_username
  password = var.gitea_token
  name     = "Repository Secret for staging cluster"
  insecure = true
}

resource "argocd_repository" "prod_cluster" {
  repo     = "http://${var.gitea_svc}:3000/simple-gitops-poc/prod-cluster.git"
  username = var.gitea_admin_username
  password = var.gitea_token
  name     = "Repository Secret for prod cluster"
  insecure = true
}

resource "argocd_application" "dev_application_ms" {
  metadata {
    name      = "dev-parent-application-ms"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.dev_project.metadata[0].name

    source {
      repo_url        = "http://${var.gitea_svc}:3000/simple-gitops-poc/dev-cluster.git"
      target_revision = "main"
      path            = "applications"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "dev"
    }

    sync_policy {
      automated {
        self_heal   = true
        allow_empty = true
      }
      managed_namespace_metadata {
        annotations = {
          "CreateNamespace" : "true"
        }
      }
    }
  }
}

resource "argocd_application" "staging_application_ms" {
  metadata {
    name      = "staging-parent-application-ms"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.staging_project.metadata[0].name

    source {
      repo_url        = "http://${var.gitea_svc}:3000/simple-gitops-poc/staging-cluster.git"
      target_revision = "main"
      path            = "applications"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "staging"
    }
    sync_policy {
      automated {
        self_heal   = true
        allow_empty = true
      }
      managed_namespace_metadata {
        annotations = {
          "CreateNamespace" : "true"
        }
      }
    }
  }
}

resource "argocd_application" "prod_application_ms" {
  metadata {
    name      = "prod-parent-application-ms"
    namespace = "argocd"
  }

  spec {
    project = argocd_project.prod_project.metadata[0].name

    source {
      repo_url        = "http://${var.gitea_svc}:3000/simple-gitops-poc/prod-cluster.git"
      target_revision = "main"
      path            = "applications"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "prod"
    }
    sync_policy {
      automated {
        self_heal   = true
        allow_empty = true
      }
      managed_namespace_metadata {
        annotations = {
          "CreateNamespace" : "true"
        }
      }
    }
  }
}