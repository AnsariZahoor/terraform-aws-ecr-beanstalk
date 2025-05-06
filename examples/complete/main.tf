provider "aws" {
  region = "us-west-2"
}

##################################################
# Complete example with new ECR repository
##################################################

module "ecr_beanstalk_complete" {
  source = "../../"  # In actual usage, this would be the module source from registry

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
    ManagedBy   = "Terraform"
  }
}