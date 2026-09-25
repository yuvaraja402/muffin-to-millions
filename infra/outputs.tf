# S3 outputs
## S3 state bucket
output "s3_state_bucket_name" {
  description = "S3 bucket containing Terraform state"
  value       = module.s3-state-bucket.s3_bucket_id
}
output "s3_state_bucket_arn" {
  description = "ARN of the Terraform state bucket"
  value       = module.s3-state-bucket.s3_bucket_arn
}
output "s3_state_bucket_url" {
  description = "S3 URL for the Terraform state bucket"
  value       = "s3://${module.s3-state-bucket.s3_bucket_id}"
}

## S3 artifacts bucket
# output "s3_artifacts_bucket_name" {
#   description = "S3 bucket for storing artifacts"
#   value       = module.s3-artifacts-bucket.s3_bucket_id
# }
# output "s3_artifacts_bucket_arn" {
#   description = "ARN of the artifacts bucket"
#   value       = module.s3-artifacts-bucket.s3_bucket_arn
# }
# output "s3_artifacts_bucket_url" {
#   description = "S3 URL for the artifacts bucket"
#   value       = "s3://${module.s3-artifacts-bucket.s3_bucket_id}"
# }



# ECR outputs
output "ecr_repository_name" {
  description = "ECR repository name"
  value       = module.ecr.repository_name
}
output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}
output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}


# EKS outputs
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}
output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}
output "eks_cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
}