echo "Cluster-name: minikube"
echo "Configuring minikube local docker instance for images..."

eval $(minikube docker-env)
