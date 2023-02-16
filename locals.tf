
locals {
  name = basename(path.cwd)
  # var.cluster_name is for Terratest
  cluster_name = var.cluster_name
  region       = var.region

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  eks_manager = var.eks_manager

  tags = {
    environment = var.environment
    projectName = var.project_name,
    Blueprint   = local.name
    GithubRepo  = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}
