#!/bin/bash

echo "Creating 'loki' namespace..."
kubectl create namespace loki

echo "Installing 'promtail' using helm..."
helm upgrade --install promtail grafana/promtail --namespace loki

echo "Installing 'loki' using helm..."
helm upgrade --install --namespace loki loki grafana/loki -f k8s/grafana/loki.yaml