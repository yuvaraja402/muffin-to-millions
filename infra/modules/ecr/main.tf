module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 3.0"

  repository_name = var.repository_name

  repository_type = "private"

  repository_image_tag_mutability = var.image_tag_mutability

  repository_encryption_type = "AES256"

  create_lifecycle_policy = true

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1

        description = "Keep last 30 images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 30
        }

        action = {
          type = "expire"
        }
      }
    ]
  })


  tags = var.tags
}