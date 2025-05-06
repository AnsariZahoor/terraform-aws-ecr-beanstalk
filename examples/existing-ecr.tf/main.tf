provider "aws" {
  region = "us-east-1"
}

##################################################
# Example using an existing ECR repository
##################################################

module "existing_ecr_beanstalk" {
  source = "../../"  # In actual usage, this would be the module source from registry

  # ECR Configuration - Using Existing
  create_ecr_repo      = false
  ecr_repo_name        = "existing-application"
  existing_ecr_repo_arn = "arn:aws:ecr:us-east-1:123456789012:repository/existing-application"

  # Elastic Beanstalk Configuration
  beanstalk_app_name          = "existing-app"
  beanstalk_env_name          = "existing-app-staging"
  beanstalk_solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Docker"
  beanstalk_tier              = "WebServer"
  beanstalk_instance_type     = "t3.micro"
  beanstalk_min_instances     = 1
  beanstalk_max_instances     = 3
  
  # Environment Variables
  beanstalk_environment_variables = {
    ENV = "staging"
    DEBUG = "true"
  }
  
  tags = {
    Environment = "Staging"
    Project     = "ExistingApp"
    ManagedBy   = "Terraform"
  }
}