output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}

output "eks_cluster_id" {
  value = module.eks_blueprints.eks_cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks_blueprints.eks_cluster_endpoint
}

output "ecr_arn" {
  value = module.ecr.repository_arn
}

output "ecr_endpoint" {
  value = module.ecr.repository_url
}

output "etp_test_server_url" {
  value = aws_lb.etp_development_server_lb.dns_name
}
