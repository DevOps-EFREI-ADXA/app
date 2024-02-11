```bash
kubectl apply -f k8s/k8s-dev.yaml -n development
```

```bash
kubectl get po -n development
```

```bash
minikube service st2dce-application -n development
```

```bash
minikube service st2dce-application -n development
```

## Prometheus

```bash
helm install prometheus prometheus-community/prometheus -n monitoring -f k8s/prometheus.yaml
```

```bash
kubectl get pod -n monitoring
```

docker build --tag app:latest --build-arg VARIABLE=0.0.1-SNAPSHOT .