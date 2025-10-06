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