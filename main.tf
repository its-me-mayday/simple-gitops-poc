terraform {
  required_providers {
    gitea = {
      source = "go-gitea/gitea"
      version = "0.7.0"
    }
  }
}

provider "gitea" {
  base_url = var.gitea_url
  username = var.gitea_username
  password = var.gitea_password
  insecure = true 
}

resource "gitea_org" "test_org" {
  name = "simple-gitops-poc"
}

resource "gitea_repository" "dev_repo" {
  username = gitea_org.test_org.name
  name = "cluster-dev-poc"
}

resource "gitea_repository" "staging_repo" {
  username = gitea_org.test_org.name
  name = "cluster-staging-poc"
}

resource "gitea_repository" "prod_repo" {
  username = gitea_org.test_org.name
  name = "cluster-prod-poc"
}

resource "gitea_token" "test_token" {
  name   = "test_token"
  scopes = ["all"]
}

output "token" {
  value     = resource.gitea_token.test_token.token
  sensitive = true
}