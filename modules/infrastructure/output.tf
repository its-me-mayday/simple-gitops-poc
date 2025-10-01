output "kind" {
  description = "Cluster kind resource"
  value       = kind_cluster.my_cluster
}

output "argocd" {
  description = "ArgoCD resource"
  value       = helm_release.argocd
}

output "gitea" {
  description = "Gitea resource"
  value       = helm_release.gitea
}

output "cnpg_operator" {
  description = "cnpg operator resource"
  value       = helm_release.cnpg_operator
}

output "cnpg_cluster_gitea" {
  description = "CNPG cluster GiTea"
  value       = helm_release.cnpg_cluster_gitea
}
