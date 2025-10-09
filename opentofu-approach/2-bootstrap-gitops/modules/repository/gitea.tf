resource "gitea_org" "simple_gitops_poc_org" {
  name = "simple-gitops-poc"
}

resource "gitea_repository" "dev_repo" {
  username = gitea_org.simple_gitops_poc_org.name
  name     = "dev-cluster"
}

resource "gitea_repository" "staging_repo" {
  username = gitea_org.simple_gitops_poc_org.name
  name     = "staging-cluster"
}

resource "gitea_repository" "prod_repo" {
  username = gitea_org.simple_gitops_poc_org.name
  name     = "prod-cluster"
}

resource "gitea_repository" "shared_infra_repo" {
  username = gitea_org.simple_gitops_poc_org.name
  name     = "shared-infra"
}