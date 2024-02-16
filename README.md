# DevOps ADXA

## Build Docker image

```bash
docker build --tag app:latest --build-arg VARIABLE=0.0.1-SNAPSHOT .
```

## Deploy the application in Kubernetes

```bash
kubectl create namespace development
kubectl create namespace production

kubectl apply -f k8s/k8s-dev.yaml --namespace development
kubectl apply -f k8s/k8s-prod.yaml --namespace production
```

## Install monitoring tools

### Metrics (Prometheus)

```bash
 ./scripts/install-prometheus.sh YOUR_EMAIL@email.com YOUR_PASSWORD to@email.com
```

### Logs (Loki)

```bash
 ./scripts/install-loki.sh
```

## Port forward

```bash
# Application
kubectl port-forward deployment/st2dce-application 8080 --namespace development
kubectl port-forward deployment/st2dce-application 8080 --namespace production

# Prometheus
export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace prometheus port-forward $POD_NAME 9090

# Grafana
export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace prometheus port-forward $POD_NAME 3000

# Promtail
kubectl --namespace loki port-forward daemonset/promtail 3101
```

Prometheus url: http://localhost:9090

You can check your active application pods on http://localhost:9090/targets

Get Grafana admin password:

```bash
kubectl get secret --namespace prometheus grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Go to the Grafana url: http://localhost:3000

You can import `k8s/grafana/dashboards/requests-dashboard.json` and `k8s/grafana/dashboards/logging-dashboard.json` in Grafana.

Loki url: (http://localhost:3100)

## Update Prometheus

```bash
helm upgrade prometheus prometheus-community/prometheus -n prometheus -f k8s/prometheus.yaml \
  --set 'alertmanager.config.receivers[0].email_configs[0].to=to@email.com' \
  --set 'alertmanager.config.receivers[0].email_configs[0].from=YOUR_EMAIL@email.com' \
  --set 'alertmanager.config.receivers[0].email_configs[0].auth_username=YOUR_EMAIL@email.com' \
  --set 'alertmanager.config.receivers[0].email_configs[0].auth_identity=YOUR_EMAIL@email.com'

helm get values prometheus -n prometheus
```

## Clean up

```bash
helm uninstall prometheus -n prometheus
helm uninstall grafana -n prometheus
helm uninstall loki -n loki
kubectl delete secret alertmanager-smtp-secret -n prometheus

kubectl delete deploy --all -n development
kubectl delete deploy --all -n production
kubectl delete service --all -n development
kubectl delete service --all -n production
kubectl delete namespace development production prometheus
```

## Acknowledge

### Prometheus

[Kubernetes awesome alert rules](https://samber.github.io/awesome-prometheus-alerts/rules#kubernetes)

[Prometheus, Alert Manager, Email Notification & Grafana in Kubernetes Monitoring | Merciboi - Youtube](https://www.youtube.com/watch?v=TyBsKMTDl1Q)

[Monitoring a Spring Boot application in Kubernetes with Prometheus - Medium](https://blog.devops.dev/monitoring-a-spring-boot-application-in-kubernetes-with-prometheus-a2d4ec7f9922)

### Loki

[Get Log Output in JSON](https://www.baeldung.com/java-log-json-output)

[Spring Boot logging with Loki, Promtail, and Grafana (Loki stack) ](https://dev.to/luafanti/spring-boot-logging-with-loki-promtail-and-grafana-loki-stack-aep)
