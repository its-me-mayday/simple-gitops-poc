locals {
  charts = {
    calico = {
      chart_name   = "tigera-operator"
      namespace    = "calico"
      release_name = "calico"
      repository   = "https://docs.tigera.io/calico/charts"
      version      = "v3.29.3"
    }
    argocd = {
      chart_name   = "argo-cd"
      namespace    = "argocd"
      release_name = "argocd"
      repository   = "https://argoproj.github.io/argo-helm"
      version      = "v8.5.5"
    }
    cnpg = {
      chart_name   = "cloudnative-pg"
      namespace    = "cnpg-system"
      release_name = "cnpg-operator"
      repository   = "https://cloudnative-pg.github.io/charts"
      version      = "v0.26.0"
    }
    gitea = {
      chart_name   = "gitea"
      namespace    = "gitea"
      release_name = "gitea"
      repository   = "https://dl.gitea.com/charts"
      version      = "v12.3.0"
    }
  }
}

#
# kubectl create ns gitea
# kubectl apply -f cr.cluster.yaml --namespace gitea
#