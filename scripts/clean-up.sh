#!/bin/bash

echo "Uninstalling 'prometheus'..."
helm uninstall prometheus -n prometheus
echo "Uninstalling 'grafana'..."
helm uninstall grafana -n prometheus
echo "Uninstalling 'loki'..."
helm uninstall loki -n loki
echo "Uninstalling 'alertmanager-smtp-secret' secret..."
kubectl delete secret alertmanager-smtp-secret -n prometheus

echo "Deleting 'development' namespace..."
echo "Deleting 'production' namespace..."
kubectl delete deploy --all -n development
kubectl delete deploy --all -n production
kubectl delete service --all -n development
kubectl delete service --all -n production

echo "Deleting 'prometheus', 'loki' namespace..."
kubectl delete namespace development production prometheus loki

echo "************************************"
echo "*                                  *"
echo "*     Clean up completed           *"
echo "*                                  *"
echo "************************************"