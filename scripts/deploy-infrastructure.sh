#!/bin/bash

env=$(echo "$1" | tr -d '\r')
versionNumber=$(echo "$2" | tr -d '\r')
file="k8s/k8s-prod.yaml"

if [ "$env" == "development" ]; then
  file="k8s/k8s-dev.yaml"
fi

# Start Minikube cluster
minikube start 

minikube kubectl -- create namespace "$env" --dry-run=client -o yaml | minikube kubectl -- apply -f -

minikube kubectl -- config set-context --current --namespace="$env"

sed -i "s/<VERSION>/${versionNumber}/g" "$file"

minikube kubectl -- apply -f "$file"

