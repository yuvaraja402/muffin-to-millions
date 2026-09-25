module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  name               = "${var.project_name}-eks"
  kubernetes_version = "1.36"

  # EKS API endpoint
  endpoint_public_access = true

  # Grant the Terraform caller administrator access to the cluster
  enable_cluster_creator_admin_permissions = true

  # EKS Auto Mode compute configuration
  compute_config = {
    enabled = true
    # Built-in pools are amd64-only. "system" stays as a landing zone for
    # tainted critical add-ons; app workloads go to the arm64 NodePool below.
    node_pools = ["system"]
  }

  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}