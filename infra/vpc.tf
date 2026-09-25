# Creating a VPC Setup for Amazon EKS and Its Components

# Order of Resource Creation:

# 1. VPC — CIDR: 10.0.0.0/16
# 2. Subnets — Public and Private
#    - Public:  10.0.0.0/24
#    - Private: 10.0.2.0/24
# 3. Internet Gateway
# 4. Attach Internet Gateway to the VPC
# 5. Public Route Table
# 6. Default Route (0.0.0.0/0) → Internet Gateway
# 7. Associate Public Subnets with the Public Route Table
# 8. Private Route Table
# 9. Associate Private Subnets with the Private Route Table
# 10. Elastic IP Address
# 11. NAT Gateway — created in a Public Subnet and associated with the Elastic IP
# 12. Default Route (0.0.0.0/0) → NAT Gateway in the Private Route Table
# 13. Security Groups
# 14. EKS Cluster and Supporting Resources


# Minimal VPC for EKS — public subnets only, no NAT gateways.
#
# EKS requires subnets in at least TWO availability zones, so public_a and
# public_b are both kept. Everything else is commented out.
#
# Removed vs the previous setup: 3 NAT gateways, 3 elastic IPs, 3 private
# subnets, 3 private route tables and their routes/associations.
# Saving: roughly $138 CAD/month.
#
# Trade-off: nodes now sit in public subnets with public IPs. Acceptable for
# dev. For production, put nodes back in private subnets behind a NAT.


# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

# ============================================================
# Internet Gateway
# ============================================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-igw"
  }
}

# ============================================================
# PUBLIC SUBNETS
# Two AZs minimum — EKS will not create a cluster with one.
# ============================================================

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "eks-public-a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "eks-public-b"
    "kubernetes.io/role/elb" = "1"
  }
}

# resource "aws_subnet" "public_d" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "${var.region}d"
#   map_public_ip_on_launch = true
#
#   tags = {
#     Name                     = "eks-public-d"
#     "kubernetes.io/role/elb" = "1"
#   }
# }

# ============================================================
# PRIVATE SUBNETS — removed (required NAT gateways)
# ============================================================

# resource "aws_subnet" "private_a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.10.0/24"
#   availability_zone = "${var.region}a"
#
#   tags = {
#     Name                              = "eks-private-a"
#     "kubernetes.io/role/internal-elb" = "1"
#   }
# }

# resource "aws_subnet" "private_b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.11.0/24"
#   availability_zone = "${var.region}b"
#
#   tags = {
#     Name                              = "eks-private-b"
#     "kubernetes.io/role/internal-elb" = "1"
#   }
# }

# resource "aws_subnet" "private_d" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.12.0/24"
#   availability_zone = "${var.region}d"
#
#   tags = {
#     Name                              = "eks-private-d"
#     "kubernetes.io/role/internal-elb" = "1"
#   }
# }

# ============================================================
# PUBLIC ROUTE TABLE
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# ============================================================
# PUBLIC ROUTE TABLE ASSOCIATIONS
# ============================================================

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# resource "aws_route_table_association" "public_d" {
#   subnet_id      = aws_subnet.public_d.id
#   route_table_id = aws_route_table.public.id
# }

# ============================================================
# ELASTIC IPs — removed with the NAT gateways
# ============================================================

# resource "aws_eip" "nat_a" {
#   domain     = "vpc"
#   tags       = { Name = "eks-nat-a-eip" }
#   depends_on = [aws_internet_gateway.main]
# }

# resource "aws_eip" "nat_b" {
#   domain     = "vpc"
#   tags       = { Name = "eks-nat-b-eip" }
#   depends_on = [aws_internet_gateway.main]
# }

# resource "aws_eip" "nat_d" {
#   domain     = "vpc"
#   tags       = { Name = "eks-nat-d-eip" }
#   depends_on = [aws_internet_gateway.main]
# }

# ============================================================
# NAT GATEWAYS — removed. This was the main cost.
# ============================================================

# resource "aws_nat_gateway" "az_a" {
#   allocation_id = aws_eip.nat_a.id
#   subnet_id     = aws_subnet.public_a.id
#   tags          = { Name = "eks-nat-a" }
#   depends_on    = [aws_internet_gateway.main]
# }

# resource "aws_nat_gateway" "az_b" {
#   allocation_id = aws_eip.nat_b.id
#   subnet_id     = aws_subnet.public_b.id
#   tags          = { Name = "eks-nat-b" }
#   depends_on    = [aws_internet_gateway.main]
# }

# resource "aws_nat_gateway" "az_d" {
#   allocation_id = aws_eip.nat_d.id
#   subnet_id     = aws_subnet.public_d.id
#   tags          = { Name = "eks-nat-d" }
#   depends_on    = [aws_internet_gateway.main]
# }

# ============================================================
# PRIVATE ROUTE TABLES — removed
# ============================================================

# resource "aws_route_table" "private_a" {
#   vpc_id = aws_vpc.main.id
#   tags   = { Name = "eks-private-a-rt" }
# }

# resource "aws_route_table" "private_b" {
#   vpc_id = aws_vpc.main.id
#   tags   = { Name = "eks-private-b-rt" }
# }

# resource "aws_route_table" "private_d" {
#   vpc_id = aws_vpc.main.id
#   tags   = { Name = "eks-private-d-rt" }
# }

# ============================================================
# PRIVATE ROUTES — removed
# ============================================================

# resource "aws_route" "private_a_internet" {
#   route_table_id         = aws_route_table.private_a.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.az_a.id
# }

# resource "aws_route" "private_b_internet" {
#   route_table_id         = aws_route_table.private_b.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.az_b.id
# }

# resource "aws_route" "private_d_internet" {
#   route_table_id         = aws_route_table.private_d.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.az_d.id
# }

# ============================================================
# PRIVATE ROUTE TABLE ASSOCIATIONS — removed
# ============================================================

# resource "aws_route_table_association" "private_a" {
#   subnet_id      = aws_subnet.private_a.id
#   route_table_id = aws_route_table.private_a.id
# }

# resource "aws_route_table_association" "private_b" {
#   subnet_id      = aws_subnet.private_b.id
#   route_table_id = aws_route_table.private_b.id
# }

# resource "aws_route_table_association" "private_d" {
#   subnet_id      = aws_subnet.private_d.id
#   route_table_id = aws_route_table.private_d.id
# }
