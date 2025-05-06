output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = var.create_ecr_repo ? aws_ecr_repository.this[0].repository_url : "Using existing repository"
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = local.ecr_repo_arn
}

output "beanstalk_application_name" {
  description = "The name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.this.name
}

output "beanstalk_environment_id" {
  description = "The ID of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.id
}

output "beanstalk_environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.name
}

output "beanstalk_endpoint_url" {
  description = "The URL to the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.this.endpoint_url
}