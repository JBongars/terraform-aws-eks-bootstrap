variable "project_name" {
  description = "Name of the project to be saved in tags"
  default     = "my_eks_template"
  type        = string
}

variable "environment" {
  description = "Environment to deploy terraform template"
  default     = "production"
  type        = string
}

variable "cluster_name" {
  description = "cluster name for terratest"
  default     = "my_cluster"
  type        = string
}

variable "eks_max_node_group_size" {
  description = "maximum eks node group cluster size"
  default     = 3
}
variable "eks_desired_node_group_size" {
  description = "desired eks node group cluster size"
  default     = 2
}

variable "eks_node_group_instance_type" {
  description = "what ec2 instance type to provision eks cluster"
  default     = "t3.small"
}


variable "region" {
  description = "self-descriptive"
  default     = "us-west-2"
  type        = string
}

variable "vpc_cidr" {
  description = "self-descriptive"
  default     = "10.0.0.0/16"
  type        = string

}

variable "bastion_ingress_cidr_blocks" {
  description = "whitelisted IP address range that is allowed to access the bastion server"
  type        = list(string)
}

variable "eks_manager" {
  type = object({
    arn : string,
    username : string
  })
}
