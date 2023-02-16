

resource "aws_key_pair" "etp_development_server_key_pair" {
  key_name   = "etp_development_server_key_pair"
  public_key = file("./keys/etp_development_server_key.pub")
}

resource "aws_security_group" "etp_development_server_security_group" {
  name        = "etp_development_server_security_group"
  description = "ETP Development Server Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "any"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 9999
    protocol    = "tcp"
  }

  egress {
    description = "any"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 9999
    protocol    = "tcp"
  }
}

resource "aws_lb" "etp_development_server_lb" {
  name               = "etp-development-server-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "etp_development_server_lb_target_group" {
  name     = "etp-development-server-lbtg"
  port     = 22
  protocol = "TCP"
  # target_type = "ip"
  vpc_id = module.vpc.vpc_id

  # prevents following error:
  # Error: deleting Target Group: ResourceInUse: Target group is currently in use by a listener or a rule
  # source: https://stackoverflow.com/questions/57183814/error-deleting-target-group-resourceinuse-when-changing-target-ports-in-aws-thr
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lb_target_group_attachment" "etp_development_server_lb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.etp_development_server_lb_target_group.arn
  target_id        = module.etp_development_server.id
  port             = 22
}

resource "aws_lb_listener" "etp_development_server_lb_listener" {
  load_balancer_arn = aws_lb.etp_development_server_lb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.etp_development_server_lb_target_group.arn
    type             = "forward"
  }
}


module "etp_development_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  name    = "etp_development_server"

  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.etp_development_server_key_pair.id
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.etp_development_server_security_group.id]
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
