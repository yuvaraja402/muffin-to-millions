output "repository_name" {
  description = "ECR repository name"
  value       = module.ecr.repository_name
}

output "repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}

output "registry_id" {
  description = "AWS account ID owning the ECR registry"
  value       = module.ecr.repository_registry_id
}