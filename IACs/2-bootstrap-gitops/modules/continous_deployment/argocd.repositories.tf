
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