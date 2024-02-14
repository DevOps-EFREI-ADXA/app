# DevOps ADXA

## Build Docker image

```bash
docker build --tag app:latest --build-arg VARIABLE=0.0.1-SNAPSHOT .
```

## Deploy in Kubernetes

```bash
kubectl create namespace development
kubectl create namespace production
kubectl create namespace monitoring

# Only support Office 365 email.
kubectl create secret generic alertmanager-smtp-secret --from-literal=auth_password='YOUR_EMAIL_PASSWORD' -n monitoring

kubectl apply -f k8s/k8s-dev.yaml -n development
kubectl apply -f k8s/k8s-prod.yaml -n production
```

## Install monitoring tools Prometheus + Grafana

```bash
helm install prometheus prometheus-community/prometheus -n monitoring -f k8s/prometheus.yaml \
  --set 'alertmanager.config.receivers[0].email_configs[0].to=to@email.com' \
  --set 'alertmanager.config.receivers[0].email_configs[0].from=your_email@email.com' \
  --set 'alertmanager.config.receivers[0].email_configs[0].auth_username=your_email@email.com' \
  --set 'alertmanager.config.receivers[0].email_configs[0].auth_identity=your_email@email.com'

# You should enclose each line of '--set' with a single quote to prevent Zsh from interpreting square brackets.

helm install grafana grafana/grafana -n monitoring -f k8s/grafana/grafana.yaml
```

## Run

```bash
minikube service st2dce-application -n development
minikube service st2dce-application -n production

# Run Prometheus
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9090

# Get Grafana admin password
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Run Grafana
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 3000
```

Prometheus url: http://localhost:9090

You can check your active application pods on http://localhost:9090/targets

Grafana url: http://localhost:3000

You can import `k8s/grafana/dashboards/requests-dashboard.json` in Grafana.

## Update Prometheus

```bash
helm upgrade prometheus prometheus-community/prometheus -n monitoring -f k8s/prometheus.yaml \
  --set 'alertmanager.config.receivers[0].email_configs[0].to=xing.chen@efrei.net' \
  --set 'alertmanager.config.receivers[0].email_configs[0].from=xing.chen@efrei.net' \
  --set 'alertmanager.config.receivers[0].email_configs[0].auth_username=xing.chen@efrei.net' \
  --set 'alertmanager.config.receivers[0].email_configs[0].auth_identity=xing.chen@efrei.net'

helm get values prometheus -n monitoring
```

## Clean up

```bash
helm uninstall prometheus -n monitoring
helm uninstall grafana -n monitoring
kubectl delete secret alertmanager-smtp-secret -n monitoring

kubectl delete deploy --all -n development
kubectl delete deploy --all -n production
kubectl delete service --all -n development
kubectl delete service --all -n production
kubectl delete namespace development production monitoring
```

## Acknowledge

[Kubernetes awesome alert rules](https://samber.github.io/awesome-prometheus-alerts/rules#kubernetes)

[Prometheus, Alert Manager, Email Notification & Grafana in Kubernetes Monitoring | Merciboi - Youtube](https://www.youtube.com/watch?v=TyBsKMTDl1Q)

[Monitoring a Spring Boot application in Kubernetes with Prometheus - Medium](https://blog.devops.dev/monitoring-a-spring-boot-application-in-kubernetes-with-prometheus-a2d4ec7f9922)
