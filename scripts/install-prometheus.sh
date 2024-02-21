#!/bin/bash

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <email> <password> <to> <smarthost>"
  exit 1
fi

EMAIL=$1
PASSWORD="$2"
TO=$3
SMARTHOST="$4"

echo "Creating 'prometheus' namespace..."
kubectl create namespace prometheus

echo "Creating 'alertmanager-smtp-secret' secret..."
kubectl create secret generic alertmanager-smtp-secret --from-literal=auth_password="$PASSWORD" --namespace prometheus

echo "Installing 'prometheus' using helm..."
helm install prometheus prometheus-community/prometheus --namespace prometheus -f k8s/prometheus.yaml \
  --set "alertmanager.config.receivers[0].email_configs[0].to=$TO" \
  --set "alertmanager.config.receivers[0].email_configs[0].from=$EMAIL" \
  --set "alertmanager.config.receivers[0].email_configs[0].auth_username=$EMAIL" \
  --set "alertmanager.config.receivers[0].email_configs[0].auth_identity=$EMAIL" \
  --set "alertmanager.config.receivers[0].email_configs[0].smarthost=$SMARTHOST"
# You should enclose each line of '--set' with a single quote to prevent Zsh from interpreting square brackets.

echo "Installing 'grafana' using helm..."
helm upgrade --install grafana grafana/grafana --namespace prometheus -f k8s/grafana/grafana.yaml