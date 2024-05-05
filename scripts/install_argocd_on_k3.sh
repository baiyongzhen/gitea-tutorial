#!/bin/bash

set -e

# Install k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=" --write-kubeconfig-mode=644" sh -
systemctl status k3s
kubectl get ns

# Install ArgoCD
wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -O install.yaml
kubectl create ns argocd
kubectl apply -n argocd -f install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

#kubectl get all -n argocd
kubectl get svc -n argocd
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d