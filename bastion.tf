

# resource "aws_key_pair" "etp_bastion_host_key_pair" {
#   key_name   = "etp_bastion_host_key_pair"
#   public_key = file("./keys/etp_bastion_host_key.pub")
# }

# resource "aws_security_group" "etp_bastion_host_security_group" {
#   name        = "etp_bastion_host_security_group"
# #   description = "ETP Development Server Security Group"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "whitelist"
#     cidr_blocks = local.bastion_ingress_cidr_blocks
#     from_port   = 0
#     to_port     = 0
#     protocol    = "tcp"
#   }

#   egress {
#     description = "any"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#   }
# }

# resource "aws_lb" "etp_bastion_host_lb" {
#   name               = "etp-bastion-host-lb"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = module.vpc.public_subnets

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# resource "aws_lb_target_group" "etp_bastion_host_lb_target_group" {
#   name     = "etp-bastion-host-lbtg"
#   port     = 22
#   protocol = "TCP"
#   target_type = "instance"
#   vpc_id = module.vpc.vpc_id

#   health_check {
#     enabled            = true
#     interval           = 30
#     port               = "traffic-port"
#     protocol           = "TCP"
#     timeout            = 10
#     unhealthy_threshold = 10
#   }

#   # prevents following error:
#   # Error: deleting Target Group: ResourceInUse: Target group is currently in use by a listener or a rule
#   # source: https://stackoverflow.com/questions/57183814/error-deleting-target-group-resourceinuse-when-changing-target-ports-in-aws-thr
#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# resource "aws_lb_target_group_attachment" "etp_bastion_host_lb_target_group_attachment" {
#   target_group_arn = aws_lb_target_group.etp_bastion_host_lb_target_group.arn
#   target_id        = module.etp_bastion_host.id
#   port             = 22
# }

# resource "aws_lb_listener" "etp_bastion_host_lb_listener" {
#   load_balancer_arn = aws_lb.etp_bastion_host_lb.arn
#   port              = 22
#   protocol          = "TCP"

#   default_action {
#     target_group_arn = aws_lb_target_group.etp_bastion_host_lb_target_group.arn
#     type             = "forward"
#   }
# }

# module "etp_bastion_host" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"
#   name    = "etp_bastion_host"

#   ami                         = data.aws_ami.ubuntu.image_id
#   instance_type               = "t3.micro"
#   key_name                    = aws_key_pair.etp_bastion_host_key_pair.id
#   monitoring                  = true
#   vpc_security_group_ids      = [aws_security_group.etp_bastion_host_security_group.id]
#   subnet_id                   = module.vpc.private_subnets[0]
#   associate_public_ip_address = false

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
