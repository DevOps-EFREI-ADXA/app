echo "Waiting for deployment to be ready..."
minikube kubectl -- rollout status -w deployment/<your-deployment-name>

# Perform a basic health check
echo "Performing a basic health check..."
if minikube kubectl -- wait --for=condition=available --timeout=60s deployment/<your-deployment-name>; then
    echo "Application is running well."
else
    echo "Health check failed. Application might not be running properly."
    exit 1
fi