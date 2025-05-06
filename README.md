# AWS ECR and Elastic Beanstalk Terraform Module

This Terraform module creates an AWS Elastic Container Registry (ECR) repository and an AWS Elastic Beanstalk environment with necessary configurations. The module allows you to either create a new ECR repository or use an existing one.

## Features

- Create a new ECR repository or use an existing one
- Configure ECR repository settings like image tag mutability and scanning
- Create an Elastic Beanstalk application and environment
- Configure Elastic Beanstalk environment settings including:
  - Instance type and scaling settings
  - VPC and subnet configurations
  - Environment variables
  - Custom option settings

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.0 |

## Usage

### Creating a new ECR repository and Elastic Beanstalk environment

```hcl
module "app_deployment" {
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
  
  # VPC Configuration (Optional)
  beanstalk_vpc_id       = "vpc-12345678"
  beanstalk_subnets      = ["subnet-12345678", "subnet-87654321"]
  beanstalk_elb_subnets  = ["subnet-23456789", "subnet-98765432"]
  
  # Environment Variables
  beanstalk_environment_variables = {
    ENV      = "production"
    LOG_LEVEL = "info"
  }
  
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```

### Using an existing ECR repository

```hcl
module "app_deployment" {
  source = "./modules/ecr-beanstalk"

  # ECR Configuration
  create_ecr_repo      = false
  ecr_repo_name        = "existing-application"
  existing_ecr_repo_arn = "arn:aws:ecr:us-west-2:123456789012:repository/existing-application"

  # Elastic Beanstalk Configuration
  beanstalk_app_name          = "existing-app"
  beanstalk_env_name          = "existing-app-staging"
  beanstalk_solution_stack_name = "64bit Amazon Linux 2 v3.5.0 running Docker"
  
  # Other configuration options...
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| create_ecr_repo | Whether to create a new ECR repository or use an existing one | `bool` | `true` | no |
| ecr_repo_name | Name of the ECR repository to create or use | `string` | n/a | yes |
| existing_ecr_repo_arn | ARN of existing ECR repository (required if create_ecr_repo = false) | `string` | `""` | no |
| ecr_image_tag_mutability | The tag mutability setting for the ECR repository | `string` | `"MUTABLE"` | no |
| ecr_scan_on_push | Indicates whether images are scanned after being pushed to the repository | `bool` | `true` | no |
| beanstalk_app_name | The name of the Elastic Beanstalk application | `string` | n/a | yes |
| beanstalk_env_name | The name of the Elastic Beanstalk environment | `string` | n/a | yes |
| beanstalk_solution_stack_name | Solution stack name for Elastic Beanstalk environment | `string` | n/a | yes |
| beanstalk_tier | Elastic Beanstalk environment tier | `string` | `"WebServer"` | no |
| beanstalk_instance_type | Instance type for EC2 instances in the environment | `string` | `"t3.micro"` | no |
| beanstalk_min_instances | Minimum number of instances in the Elastic Beanstalk environment | `number` | `1` | no |
| beanstalk_max_instances | Maximum number of instances in the Elastic Beanstalk environment | `number` | `2` | no |
| beanstalk_vpc_id | ID of the VPC where resources will be created | `string` | `null` | no |
| beanstalk_subnets | List of subnet IDs to launch resources in | `list(string)` | `null` | no |
| beanstalk_elb_subnets | List of subnet IDs for the ELB | `list(string)` | `null` | no |
| beanstalk_environment_variables | Map of environment variables for the Elastic Beanstalk environment | `map(string)` | `{}` | no |
| beanstalk_additional_settings | Additional Elastic Beanstalk settings | `list(object)` | `[]` | no |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| ecr_repository_url | The URL of the ECR repository |
| ecr_repository_arn | The ARN of the ECR repository |
| beanstalk_application_name | The name of the Elastic Beanstalk application |
| beanstalk_environment_id | The ID of the Elastic Beanstalk environment |
| beanstalk_environment_name | The name of the Elastic Beanstalk environment |
| beanstalk_endpoint_url | The URL to the Elastic Beanstalk environment |

## Notes

- The ECR repository URL is automatically added as an environment variable (`ECR_REPO_URL`) to the Elastic Beanstalk environment.
- When using an existing ECR repository, make sure the ARN is correct and the repository exists.
- For Docker environments, make sure to use an appropriate solution stack name that supports Docker.

## License

MIT