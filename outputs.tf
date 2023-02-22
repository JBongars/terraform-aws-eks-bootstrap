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

output "nextapp_prod_ca_arn" {
  value = aws_acm_certificate.nextapp-prod.arn
}

output "nextapp_dev_ca_arn" {
  value = aws_acm_certificate.nextapp-dev.arn
}

output "nextjs_repo_arn" {
  value = module.nextapp_repo.repository_arn
}

output "nextjs_repo_endpoint" {
  value = module.nextapp_repo.repository_url
}

# output "etp_bastion_dns" {
#   value = aws_lb.etp_bastion_host_lb.dns_name
# }

# output "etp_jenkins_dns" {
#   value = module.etp_jenkins.private_dns
# }