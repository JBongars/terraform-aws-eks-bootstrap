variable "project_name" {
  description = "Name of the project to be saved in tags"
  default     = "my_eks_template"
}

variable "environment" {
  description = "Environment to deploy terraform template"
  default     = "production"
}

variable "cluster_name" {
  description = "cluster name for terratest"
  default     = "my_cluster"
}

variable "region" {
  description = "self-descriptive"
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "self-descriptive"
  default     = "10.0.0.0/16"
}

variable "eks_manager" {
  type = object({
    arn : string,
    username : string
  })
}
