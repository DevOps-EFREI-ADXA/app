#!/bin/bash

env=$1
versionNumber=$2

# Start Minikube cluster
minikube start

minikube kubectl -- create namespace $env --dry-run=client -o yaml | kubectl apply -f -

minikube kubectl -- config set-context --current --namespace=$env

minikube kubectl -- apply -f k8s/k8s-dev.yaml
minikube kubectl -- set image deployment/st2dce-application st2dce-application=danny07/app:${versionNumber}
