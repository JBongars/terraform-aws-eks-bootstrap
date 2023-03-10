resource "aws_acm_certificate" "nextapp-dev" {
  domain_name       = "menyala-dev.jasycx.link"
  validation_method = "DNS"

  tags = {
    Environment = "development"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "nextapp-prod" {
  domain_name       = "menyala.jasycx.link"
  validation_method = "DNS"

  tags = {
    Environment = "production"
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints.git"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"
  create_eks      = true

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  map_users = [{
    userarn  = local.eks_manager.arn,
    username = local.eks_manager.username,
    groups = [
      "system:masters"
    ]
  }]

  managed_node_groups = {
    mng = {
      node_group_name = "managed-ondemand"
      instance_types  = [local.eks_node_group_config.node_group_instance_type] // smallest recommended instance type
      subnet_ids      = module.vpc.private_subnets

      desired_size = local.eks_node_group_config.desired_node_group_size
      max_size     = local.eks_node_group_config.max_node_group_size
      min_size     = local.eks_node_group_config.desired_node_group_size
    }
  }

  platform_teams = {
    admin = {
      users = [
        data.aws_caller_identity.current.arn
      ]
    }
  }

  tags = local.tags
}

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints.git/modules/kubernetes-addons"

  eks_cluster_id       = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider    = module.eks_blueprints.oidc_provider
  eks_cluster_version  = module.eks_blueprints.eks_cluster_version

  # EKS Managed Add-ons
  enable_amazon_eks_aws_ebs_csi_driver = true // disabled because this plugin will fail if there are no nodes in a cluster. Must be added after initial deployment
  amazon_eks_aws_ebs_csi_driver_config = {
    resolve_conflicts = "OVERWRITE",
    # addon_version = "v1.12.1-eksbuild.1"
  }

  enable_amazon_eks_coredns    = true
  enable_amazon_eks_vpc_cni    = true
  enable_amazon_eks_kube_proxy = true

  # Add-ons
  enable_aws_load_balancer_controller = true
  enable_metrics_server               = false
  enable_aws_cloudwatch_metrics       = false
  enable_kubecost                     = true
  enable_gatekeeper                   = true

  enable_cluster_autoscaler = true
  cluster_autoscaler_helm_config = {
    set = [
      {
        name  = "podLabels.prometheus\\.io/scrape",
        value = "true",
        type  = "string",
      }
    ]
  }

  enable_cert_manager = true
  cert_manager_helm_config = {
    set_values = [
      {
        name  = "extraArgs[0]"
        value = "--enable-certificate-owner-ref=false"
      },
    ]
  }

  tags = local.tags
}
