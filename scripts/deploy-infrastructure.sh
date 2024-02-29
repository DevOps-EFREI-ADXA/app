#!/bin/bash

env=$1
versionNumber=$2
file="k8s/k8s-prod.yaml"

if [ env -e "development" ]; then
  file="k8s/k8s-dev.yaml"
fi

# Start Minikube cluster
minikube start

minikube kubectl -- create namespace $env --dry-run=client -o yaml | kubectl apply -f -

minikube kubectl -- config set-context --current --namespace=$env

sed -i 's/<VERSION>/${versionNumber}/g' $file

cat k8s/k8s-dev.yaml

minikube kubectl -- apply -f $file
