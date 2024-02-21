echo "Waiting for deployment to be ready..."
minikube kubectl -- rollout status -w deployment/st2dce-application

# Perform a basic health check
echo "Performing a basic health check..."
if minikube kubectl -- wait --for=condition=available --timeout=60s deployment/st2dce-application; then
    echo "Application is running well."
else
    echo "Health check failed. Application might not be running properly."
    exit 1
fi