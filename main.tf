##################################################
# ECR REPOSITORY
##################################################

resource "aws_ecr_repository" "this" {
  count                = var.create_ecr_repo ? 1 : 0
  name                 = var.ecr_repo_name
  image_tag_mutability = var.ecr_image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }

  tags = var.tags
}

locals {
  ecr_repo_arn = var.create_ecr_repo ? aws_ecr_repository.this[0].arn : var.existing_ecr_repo_arn
  ecr_repo_url = var.create_ecr_repo ? aws_ecr_repository.this[0].repository_url : (
    var.existing_ecr_repo_arn != "" ? split("/", var.existing_ecr_repo_arn)[1] : ""
  )
}

##################################################
# ELASTIC BEANSTALK APPLICATION
##################################################

resource "aws_elastic_beanstalk_application" "this" {
  name        = var.beanstalk_app_name
  description = "Application created by Terraform"

  tags = var.tags
}

##################################################
# ELASTIC BEANSTALK ENVIRONMENT
##################################################

resource "aws_elastic_beanstalk_environment" "this" {
  name                = var.beanstalk_env_name
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = var.beanstalk_solution_stack_name
  tier                = var.beanstalk_tier

  # Base settings
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.beanstalk_instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.beanstalk_min_instances
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.beanstalk_max_instances
  }

  # VPC settings
  dynamic "setting" {
    for_each = var.beanstalk_vpc_id != null ? [1] : []
    content {
      namespace = "aws:ec2:vpc"
      name      = "VPCId"
      value     = var.beanstalk_vpc_id
    }
  }

  dynamic "setting" {
    for_each = var.beanstalk_subnets != null ? [1] : []
    content {
      namespace = "aws:ec2:vpc"
      name      = "Subnets"
      value     = join(",", var.beanstalk_subnets)
    }
  }

  dynamic "setting" {
    for_each = var.beanstalk_elb_subnets != null ? [1] : []
    content {
      namespace = "aws:ec2:vpc"
      name      = "ELBSubnets"
      value     = join(",", var.beanstalk_elb_subnets)
    }
  }

  # Environment variables
  dynamic "setting" {
    for_each = var.beanstalk_environment_variables
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }

  # Add ECR_REPO_URL as environment variable
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ECR_REPO_URL"
    value     = local.ecr_repo_url
  }

  # Additional settings
  dynamic "setting" {
    for_each = var.beanstalk_additional_settings
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
    }
  }

  tags = var.tags
}