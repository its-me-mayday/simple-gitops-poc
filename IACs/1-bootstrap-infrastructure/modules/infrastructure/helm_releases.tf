resource "helm_release" "harbor" {
  name = local.charts.harbor.release_name

  repository       = local.charts.harbor.repository
  chart            = local.charts.harbor.chart_name
  namespace        = local.charts.harbor.namespace
  create_namespace = true
  version          = local.charts.harbor.version
  values = [
    yamlencode({
      expose = {
        type = "NodePort"
        tls = {
          enabled = false
        }
      }
      trivy = {
        enabled = false
      }
      notary = {
        enabled = false
      }
      clair = {
        enabled = false
      }
      exporter = {
        enabled = false
      }
    })
  ]

  depends_on = [kind_cluster.my_cluster]
}

resource "helm_release" "argocd" {
  name = local.charts.argocd.release_name

  repository       = local.charts.argocd.repository
  chart            = local.charts.argocd.chart_name
  namespace        = local.charts.argocd.namespace
  create_namespace = true
  version          = local.charts.argocd.version

  values = [
    yamlencode({
      dex = {
        enabled = false
      }
      notifications = {
        enabled = false
      }
      server = {
        service = {
          type         = "NodePort"
          nodePortHttp = "30081"
        }
      }
    })
  ]

  depends_on = [kind_cluster.my_cluster]
}

resource "helm_release" "cnpg_operator" {
  name = local.charts.cnpg.release_name

  repository       = local.charts.cnpg.repository
  chart            = local.charts.cnpg.chart_name
  namespace        = local.charts.cnpg.namespace
  create_namespace = true
  version          = local.charts.cnpg.version

  depends_on = [kind_cluster.my_cluster]
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
  cleanup_on_fail  = true
  replace          = true

  values = [
    yamlencode({
      postgresql-ha = { enabled = false }
      postgresql    = { enabled = false }

      gitea = {
        admin = {
          existingSecret = "gitea-admin"
          usernameKey    = "username"
          passwordKey    = "password"
      } }

      service = {
        http = {
          type = "NodePort"
        }
      }
      valkey-cluster = {
        enabled = false
      },
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
          { name = "GITEA__database__SSL_MODE", value = "require" },
          { name = "GITEA__service__DEFAULT_ALLOW_CREATE_ORGANIZATION", value = "false" },
          { name = "GITEA__service__DISABLE_REGISTRATION", value = "true" }
        ]
      }
    })
  ]

  depends_on = [helm_release.cnpg_cluster_gitea, null_resource.k8s_secret]
}

locals {
  kubeconfig_abs = abspath(var.kubeconfig_path)
}

resource "null_resource" "k8s_secret" {
  depends_on = [kind_cluster.my_cluster]

  triggers = {
    ns   = local.gitea.namespace
    name = local.gitea.secret_name
    ksha = try(filesha1(local.kubeconfig_abs), "")
  }

  provisioner "local-exec" {
    command = <<-EOT
    bash -lc '
    set -euo pipefail

    KCONF="${local.kubeconfig_abs}"
    test -f "$KCONF" || { echo "Kubeconfig not found: $KCONF"; exit 1; }
    export KUBECONFIG="$KCONF"

    # Waiting for API Server
    for i in {1..60}; do
      if kubectl --request-timeout=5s get --raw=/readyz >/dev/null 2>&1; then
        break
      fi
      sleep 2
    done

    NS="${local.gitea.namespace}"
    NAME="${local.gitea.secret_name}"

    kubectl get ns "$NS" >/dev/null 2>&1 || kubectl create ns "$NS" >/dev/null

    if kubectl -n "$NS" get secret "$NAME" >/dev/null 2>&1; then
      echo "Secret $NAME is already exist in $NS, skip."
      exit 0
    fi

    set +o pipefail
    USER=$(LC_ALL=C tr -dc "a-z0-9" </dev/urandom | head -c 12)
    PASS=$(LC_ALL=C tr -dc "A-Za-z0-9" </dev/urandom | head -c 24)
    set -o pipefail
    [ -n "$USER" ] && [ -n "$PASS" ] || { echo "random generation failed"; exit 1; }

    kubectl -n "$NS" create secret generic "$NAME" \
      --from-literal=username="$USER" \
      --from-literal=password="$PASS"
    '
  EOT
  }

}