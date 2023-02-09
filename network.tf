# resource "aws_vpc" "etp_vpc" {
#   cidr_block = "10.0.0.0/16"
#   name       = "etp_vpc"

#   tags = {
#     project = "etp"
#     name    = "etp_vpc"
#   }
# }

# resource "aws_internet_gateway" "etp_igw" {
#   vpc_id = aws_vpc.etp_vpc.id

#   tags = {
#     project = "etp"
#     name    = "etp_igw"
#   }
# }

# resource "aws_subnet" "private-us-east-1a" {
#   vpc_id            = aws_vpc.etp_vpc.id
#   cidr_block        = "10.0.0.0/19"
#   availability_zone = "us-east-1a"

#   tags = {
#     "project"                         = "etp"
#     "name"                            = "private-us-east-1a"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   }
# }

# resource "aws_subnet" "private-us-east-1b" {
#   vpc_id            = aws_vpc.etp_vpc.id
#   cidr_block        = "10.0.32.0/19"
#   availability_zone = "us-east-1b"

#   tags = {
#     "project"                         = "etp"
#     "name"                            = "private-us-east-1b"
#     "kubernetes.io/role/internal-elb" = "1"
#     "kubernetes.io/cluster/demo"      = "owned"
#   }
# }

# resource "aws_subnet" "public-us-east-1a" {
#   vpc_id                  = aws_vpc.etp_vpc.id
#   cidr_block              = "10.0.64.0/19"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     "project"                    = "etp"
#     "name"                       = "public-us-east-1a"
#     "kubernetes.io/role/elb"     = "1"
#     "kubernetes.io/cluster/demo" = "owned"
#   }
# }

# resource "aws_subnet" "public-us-east-1b" {
#   vpc_id                  = aws_vpc.etp_vpc.id
#   cidr_block              = "10.0.96.0/19"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     "project"                    = "etp"
#     "name"                       = "public-us-east-1b"
#     "kubernetes.io/role/elb"     = "1"
#     "kubernetes.io/cluster/demo" = "owned"
#   }
# }

# resource "aws_eip" "etp_eip" {
#   vpc = true

#   tags = {
#     "project" = "etp"
#     "name"    = "etp_eip"
#   }
# }

# resource "aws_nat_gateway" "etp_nat" {
#   allocation_id = aws_eip.etp_eip.id
#   subnet_id     = aws_subnet.public-us-east-1a.id
#   depends_on    = [aws_internet_gateway.etp_igw]

#   tags = {
#     "project" = "etp"
#     "name"    = "etp_nat"
#   }
# }

# resource "aws_route_table" "etp_rt_private" {
#   vpc_id = aws_vpc.etp_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.etp_nat.id
#   }

#   tags = {
#     "project" = "etp"
#     "name"    = "etp_rt_private"
#   }
# }

# resource "aws_route_table" "etp_rt_public" {
#   vpc_id = aws_vpc.etp_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.etp_igw.id
#   }

#   tags = {
#     "project" = "etp"
#     "name"    = "etp_rt_public"
#   }
# }

# resource "aws_route_table_association" "private-us-east-1a" {
#   subnet_id      = aws_subnet.private-us-east-1a.id
#   route_table_id = aws_route_table.etp_rt_private.id
# }

# resource "aws_route_table_association" "private-us-east-1b" {
#   subnet_id      = aws_subnet.private-us-east-1b.id
#   route_table_id = aws_route_table.etp_rt_private.id
# }

# resource "aws_route_table_association" "public-us-east-1a" {
#   subnet_id      = aws_subnet.public-us-east-1a.id
#   route_table_id = aws_route_table.etp_rt_public.id
# }

# resource "aws_route_table_association" "public-us-east-1b" {
#   subnet_id      = aws_subnet.public-us-east-1b.id
#   route_table_id = aws_route_table.etp_rt_public.id
# }
