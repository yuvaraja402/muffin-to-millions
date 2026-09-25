module "ecr" {
  source = "./modules/ecr"

  repository_name      = "${var.project_name}-artifacts-ecr"
  image_tag_mutability = "MUTABLE"

  tags = {
    Type        = "api"
    Environment = "${var.environment}"
    ManagedBy   = "${var.tool}"
  }
}