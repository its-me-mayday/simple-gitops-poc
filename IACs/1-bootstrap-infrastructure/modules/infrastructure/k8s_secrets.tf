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