data "external" "gitea_admin_secret" {
  program = ["bash", "-lc", <<-EOS
    set -euo pipefail
    export KUBECONFIG="${abspath(local.k8s_config_path)}"
    u=$(kubectl -n "${var.gitea_namespace}" get secret "${var.gitea_secret_name}" -o jsonpath='{.data.username}' | base64 -d)
    p=$(kubectl -n "${var.gitea_namespace}" get secret "${var.gitea_secret_name}" -o jsonpath='{.data.password}' | base64 -d)
    jq -n --arg u "$u" --arg p "$p" '{username:$u, password:$p}'
  EOS
  ]
}

data "external" "argocd_admin_secret" {
  program = ["bash", "-lc", <<-EOS
    set -euo pipefail
    export KUBECONFIG="${abspath(local.k8s_config_path)}"
    p=$(kubectl -n "${var.argocd_namespace}" get secret "${var.argocd_secret_name}" -o jsonpath='{.data.password}' | base64 -d)
    jq -n --arg p "$p" '{password:$p}'
  EOS
  ]
}