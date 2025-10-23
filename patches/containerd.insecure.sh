#!/bin/bash
## Workaround without recreating cluster
## Problem solved: "http: server gave HTTP response to HTTPS client"

CLUSTER_NAME="simple-gitops-poc-cluster"

for n in $(docker ps --format '{{.Names}}' | grep ${CLUSTER_NAME}); do
  echo ">> $n"
  docker exec -it "$n" bash -lc '
    set -e
    cp /etc/containerd/config.toml /etc/containerd/config.toml.bak
    awk '"'"'
      BEGIN{mirrors=0;configs=0}
      {print}
      END{
        print "[plugins.\"io.containerd.grpc.v1.cri\".registry]"
        print "  [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors]"
        print "    [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"172.18.0.2:30080\"]"
        print "      endpoint = [\"http://172.18.0.2:30080\"]"
        print "  [plugins.\"io.containerd.grpc.v1.cri\".registry.configs]"
        print "    [plugins.\"io.containerd.grpc.v1.cri\".registry.configs.\"172.18.0.2:30080\".tls]"
        print "      insecure_skip_verify = true"
      }
    '"'"' /etc/containerd/config.toml > /etc/containerd/config.toml.new
    mv /etc/containerd/config.toml.new /etc/containerd/config.toml
    systemctl restart containerd
  '
done
