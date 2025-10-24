#!/bin/bash

kind create cluster --name simple-gitops-poc --config ./kind/cluster.kind.yaml
helm upgrade --install argo argo/argocd --version 8.5.5  --values ./argocd/values.yaml --namespace argocd --create-namespace
helm upgrade --install cnpg --version 0.26.0 --namespace cnpg-system --create-namespace cnpg/cloudnative-pg
kubectl create ns gitea
kubectl apply -f ./cnpg/cr.cluster.yaml --namespace gitea
helm upgrade --install gitea gitea/gitea --version 12.3.0 --values ./gitea/values.yaml --namespace gitea --create-namespace
helm upgrade --install harbor harbor/harbor --version 1.18.0 --namespace harbor --create-namespace --values ./harbor/values.yaml
