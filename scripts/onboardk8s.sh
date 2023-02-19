#!/bin/bash

# Container: de awskube -p 3000:3000 -v "${PWD}/.kube/:/root/.kube"

region="us-east-1"
cluster_name="my_cluster"

# connect kubectl, helm to aws cluster
aws eks --region $region update-kubeconfig --name $cluster_name
# kubectl get pods --kubeconfig ./.kube/config

# insall argocd
helm install -f ./helm/argocd/values.yaml -n argocd argod ./helm/argocd

# get argocd admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# forward argocd port to 8080
kubectl port-forward svc/argocd-server -n argocd 8080:443