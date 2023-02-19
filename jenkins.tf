# resource "aws_key_pair" "etp_jenkins_key_pair" {
#   key_name   = "etp_jenkins_key_pair"
#   public_key = file("./keys/etp_jenkins_key.pub")
# }

# resource "aws_security_group" "etp_jenkins_security_group" {
#   name        = "etp_jenkins_security_group"
#   description = "ETP Jenkins Security Group"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "any"
#     cidr_blocks = [format("%s/32", module.etp_bastion_host.private_ip)]
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#   }

#   ingress {
#     description = "any"
#     cidr_blocks = [format("%s/32", module.etp_bastion_host.private_ip)]
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#   }


#   ingress {
#     description = "any"
#     cidr_blocks = [format("%s/32", module.etp_bastion_host.private_ip)]
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#   }

#   egress {
#     description = "any"
#     cidr_blocks = [module.vpc.vpc_cidr_block]
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#   }

#   tags = local.tags
# }

# resource "aws_efs_file_system" "etp_jenkins_efs" {
#   creation_token = "example"
# }

# resource "aws_efs_mount_target" "etp_jenkins_efs_mt" {
#   file_system_id = aws_efs_file_system.etp_jenkins_efs.id
#   subnet_id      = module.vpc.private_subnets[0]
#   security_groups = [aws_security_group.etp_jenkins_security_group.id]
# }

# module "etp_jenkins" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"
#   name    = "etp_jenkins"

#   ami           = data.aws_ami.ubuntu_18.image_id
#   instance_type = "t3.micro"
#   key_name                    = aws_key_pair.etp_jenkins_key_pair.id
#   monitoring = true
#   vpc_security_group_ids = [
#     aws_security_group.etp_jenkins_security_group.id,
#     aws_security_group.etp_bastion_host_security_group.id
#   ]
#   subnet_id                   = module.vpc.private_subnets[0]
#   associate_public_ip_address = false

#   tags = merge({
#     Terraform   = "true"
#     Environment = "dev"
#   }, local.tags)
# }
