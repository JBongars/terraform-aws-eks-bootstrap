#!/bin/bash

aws eks --region example_region update-kubeconfig --name cluster_name
kubectl get pods --kubeconfig ./.kube/config
