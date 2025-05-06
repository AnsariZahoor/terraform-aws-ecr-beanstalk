provider "aws" {
  region = "us-west-2"
}

##################################################
# Basic example with minimal configuration
##################################################

module "basic_ecr_beanstalk" {
  source = "../../"  # In actual usage, this would be the module source from registry

  # ECR Configuration
  create_ecr_repo = true
  ecr_repo_name   = "simple-app"

  # Elastic Beanstalk Configuration
  beanstalk_app_name          = "simple-app"
  beanstalk_env_name          = "simple-app-dev"
  beanstalk_solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Docker"
  
  # Use defaults for the rest of the configuration
  
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}