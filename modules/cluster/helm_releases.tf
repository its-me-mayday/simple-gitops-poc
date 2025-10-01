resource "helm_release" "calico" {
  name = local.charts.calico.release_name

  repository       = local.charts.calico.repository
  chart            = local.charts.calico.chart_name
  namespace        = local.charts.calico.namespace
  create_namespace = true
  version          = local.charts.calico.version
  wait             = true

  depends_on = [kind_cluster.my_cluster]
}

resource "helm_release" "argocd" {
  name = local.charts.argocd.release_name

  repository       = local.charts.argocd.repository
  chart            = local.charts.argocd.chart_name
  namespace        = local.charts.argocd.namespace
  create_namespace = true
  version          = local.charts.argocd.version
  wait             = true

  values = [
    yamlencode({
      server = {
        service = {
          type = "NodePort"
        }
      }
    })
  ]

  depends_on = [helm_release.calico]
}

resource "helm_release" "cnpg_operator" {
  name = local.charts.cnpg.release_name

  repository       = local.charts.cnpg.repository
  chart            = local.charts.cnpg.chart_name
  namespace        = local.charts.cnpg.namespace
  create_namespace = true
  version          = local.charts.cnpg.version
  wait             = true

  depends_on = [helm_release.calico]
}

resource "helm_release" "cnpg_cluster_gitea" {
  name             = local.charts.cnpg_cluster_gitea.release_name
  repository       = local.charts.cnpg_cluster_gitea.repository
  chart            = local.charts.cnpg_cluster_gitea.chart_name
  version          = local.charts.cnpg_cluster_gitea.version
  namespace        = local.charts.cnpg_cluster_gitea.namespace
  create_namespace = true

  values = [yamlencode({
    nameOverride      = ""
    fullnameOverride  = "gitea-pg"
    namespaceOverride = ""

    type    = "postgresql"
    version = { postgresql = "16" }

    mode = "standalone"

    cluster = {
      instances = 2
      storage = {
        size = "10Gi"
      }

      initdb = {
        database = "gitea"
        owner    = "gitea"
      }

      enableSuperuserAccess = true
    }

    backups = { enabled = false }
  })]

  depends_on = [helm_release.cnpg_operator]
}

resource "helm_release" "gitea" {
  name = local.charts.gitea.release_name

  repository       = local.charts.gitea.repository
  chart            = local.charts.gitea.chart_name
  namespace        = local.charts.gitea.namespace
  create_namespace = true
  version          = local.charts.gitea.version
  wait             = true

  values = [
    yamlencode({
      postgresql-ha = { enabled = false }
      postgresql    = { enabled = false }

      service = {
        http = {
          type = "NodePort"
        }
      }

      deployment = {
        env = [
          { name = "GITEA__database__DB_TYPE", value = "postgres" },
          { name = "GITEA__database__HOST", value = "gitea-pg-rw.gitea.svc.cluster.local:5432" },
          { name = "GITEA__database__NAME", value = "gitea" },

          {
            name = "GITEA__database__USER",
            valueFrom = {
              secretKeyRef = {
                name = "gitea-pg-app"
                key  = "username"
              }
            }
          },
          {
            name = "GITEA__database__PASSWD",
            valueFrom = {
              secretKeyRef = {
                name = "gitea-pg-app"
                key  = "password"
              }
            }
          },
          { name = "GITEA__database__SSL_MODE", value = "require" }
        ]
      }
    })
  ]

  depends_on = [helm_release.cnpg_cluster_gitea]
}