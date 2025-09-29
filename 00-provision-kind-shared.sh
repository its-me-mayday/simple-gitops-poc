#!/bin/bash

kind create cluster --name simple-gitops-poc --config ./cluster.kind.yaml
helm upgrade --install my-argo argo/argocd --version 8.5.5  --values values.argocd.yaml --namespace argocd --create-namespace
kubectl apply -f cr.cluster.yaml --namespace gitea
helm upgrade --install my-gitea gitea/gitea --version 12.3.0 --values values.gitea.yaml --namespace gitea --create-namespace

