# Deployment

helm install -f .\values.yaml -n argocd argocd .

# Inspect Dashboard

kubectl port-forward svc/argocd-server -n argocd 8080:443

# Known Issues

Application Ingress is sometimes stuck on "Processing". This issue has been patched by manually appying an override in the ingress.