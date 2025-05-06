
##################################################
# Example 1: Create new ECR repository and Elastic Beanstalk
##################################################
module "app_with_new_ecr" {
  source = "./modules/ecr-beanstalk"

  # ECR Configuration
  create_ecr_repo         = true
  ecr_repo_name           = "my-application"
  ecr_image_tag_mutability = "MUTABLE"
  ecr_scan_on_push        = true

  # Elastic Beanstalk Configuration
  beanstalk_app_name          = "my-app"
  beanstalk_env_name          = "my-app-prod"
  beanstalk_solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Docker"
  beanstalk_instance_type     = "t3.small"
  beanstalk_min_instances     = 2
  beanstalk_max_instances     = 4
  
  # VPC Configuration
  beanstalk_vpc_id       = "vpc-12345678"
  beanstalk_subnets      = ["subnet-12345678", "subnet-87654321"]
  beanstalk_elb_subnets  = ["subnet-23456789", "subnet-98765432"]
  
  # Environment Variables
  beanstalk_environment_variables = {
    ENV      = "production"
    LOG_LEVEL = "info"
  }
  
  # Additional Beanstalk Settings
  beanstalk_additional_settings = [
    {
      namespace = "aws:elasticbeanstalk:environment"
      name      = "LoadBalancerType"
      value     = "application"
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name      = "HealthCheckPath"
      value     = "/health"
    }
  ]
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}

##################################################
# Example 2: Use existing ECR repository
##################################################

module "app_with_existing_ecr" {
  source = "./modules/ecr-beanstalk"

  # ECR Configuration
  create_ecr_repo      = false
  ecr_repo_name        = "existing-application"
  existing_ecr_repo_arn = "arn:aws:ecr:us-west-2:123456789012:repository/existing-application"

  # Elastic Beanstalk Configuration
  beanstalk_app_name          = "existing-app"
  beanstalk_env_name          = "existing-app-staging"
  beanstalk_solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Docker"
  beanstalk_tier              = "WebServer"
  beanstalk_instance_type     = "t3.micro"
  
  # Environment Variables
  beanstalk_environment_variables = {
    ENV = "staging"
  }
  
  tags = {
    Environment = "Staging"
    Project     = "ExistingApp"
  }
}