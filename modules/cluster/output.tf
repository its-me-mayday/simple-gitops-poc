output "kind" {
  description = "Cluster kind resource"
  value       = kind_cluster.my_cluster
}

output "calico" {
  description = "Calico resource"
  value       = helm_release.calico
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
  description = "CNPG Operator resource"
  value       = helm_release.cnpg_operator
}