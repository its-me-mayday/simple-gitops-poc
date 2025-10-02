terraform {
  required_version = ">= 1.9.1"
  required_providers {
    gitea = {
      source  = "go-gitea/gitea"
      version = "0.7.0"
    }
    external = { source = "hashicorp/external" }
  }
}

provider "gitea" {
  base_url = var.gitea_url
  username = data.external.gitea_admin_secret.result.username
  password = data.external.gitea_admin_secret.result.password
  insecure = true
}

data "external" "gitea_admin_secret" {
  program = ["bash", "-lc", <<-EOS
    set -euo pipefail
    export KUBECONFIG="${abspath(var.kubeconfig_path)}"
    u=$(kubectl -n "${var.namespace}" get secret "${var.secret_name}" -o jsonpath='{.data.username}' | base64 -d)
    p=$(kubectl -n "${var.namespace}" get secret "${var.secret_name}" -o jsonpath='{.data.password}' | base64 -d)
    jq -n --arg u "$u" --arg p "$p" '{username:$u, password:$p}'
  EOS
  ]
}