
locals {
  name = basename(path.cwd)
  # var.cluster_name is for Terratest
  cluster_name = var.cluster_name
  region       = var.region

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  eks_manager = var.eks_manager

  bastion_ingress_cidr_blocks = var.bastion_ingress_cidr_blocks
  
  eks_node_group_config = {
    max_node_group_size      = var.eks_max_node_group_size
    desired_node_group_size  = var.eks_desired_node_group_size
    node_group_instance_type = var.eks_node_group_instance_type
  }

  tags = {
    environment = var.environment
    projectName = var.project_name,
    Blueprint   = local.name
    GithubRepo  = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}
