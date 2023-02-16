# Deployment

helm install -f .\values.yaml -n argocd argocd .

# Inspect Dashboard

kubectl port-forward svc/argocd-server -n argocd 8080:443