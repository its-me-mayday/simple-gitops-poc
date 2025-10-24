# SIMPLE GITOPS POC

## Overview
The goal of this POC is to find a solution to the organization of ARGOCD application manifests to facilitate automated releases. Ultimately, this POC also aims to find an implementation of the gitops methodology.

## PoC Components
- Kind as kubernetes cluster tool;
- ArgoCD as continous deployment platform;
- Harbor as container registry platform;
- Gitea as git repository platform.

## Proposal about organization folder
This is an idea about organization folder. My assumption is based on three differente environments (DEV|STAGING|PROD):

### Repositories for microservice manifests and argo applications for microservices

```
- git-repo:dev-cluster
            /applications           # All ArgoCD applications
            /manifests              # Kubernetes manifests for microservices
                /microservice-1     # Kubernetes manifests for microservice-1
                /microservice-2     # Kubernetes manifests for microservice-2
                ...
                /microservice-n     # Kubernetes manifests for microservice-n 
- git-repo:staging-cluster
                /applications           # All ArgoCD applications
                /manifests              # Kubernetes manifests for microservices
                    /microservice-1     # Kubernetes manifests for microservice-1
                    /microservice-2     # Kubernetes manifests for microservice-2
                    ...
                    /microservice-n     # Kubernetes manifests for microservice-n 
- git-repo:prod-cluster
                /applications           # All ArgoCD applications
                /manifests              # Kubernetes manifests for microservices
                    /microservice-1     # Kubernetes manifests for microservice-1
                    /microservice-2     # Kubernetes manifests for microservice-2
                    ...
                    /microservice-n     # Kubernetes manifests for microservice-n 
```

### Repositories about microservice source codes
```
- git-repo:microservice-1
- git-repo:microservice-2
...
- git-repo:microservice-n
```