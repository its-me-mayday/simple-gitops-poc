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

resource "argocd_repository" "dev_cluster" {
  repo     = "http://${var.gitea_svc}:3000/simple-gitops-poc/dev-cluster.git"
  username = var.gitea_admin_username
  password = var.gitea_token 
  name = "Repository Secret for dev cluster"
  insecure = true
}

resource "argocd_repository" "staging_cluster" {
  repo     = "http://${var.gitea_svc}:3000/simple-gitops-poc/staging-cluster.git"
  username = var.gitea_admin_username
  password = var.gitea_token 
  name = "Repository Secret for staging cluster"
  insecure = true
}

resource "argocd_repository" "prod_cluster" {
  repo     = "http://${var.gitea_svc}:3000/simple-gitops-poc/prod-cluster.git"
  username = var.gitea_admin_username
  password = var.gitea_token
  name = "Repository Secret for prod cluster"
  insecure = true
}
