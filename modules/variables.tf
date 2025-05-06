variable "create_ecr_repo" {
  description = "Whether to create a new ECR repository or use an existing one"
  type        = bool
  default     = true
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository to create or use"
  type        = string
}

variable "existing_ecr_repo_arn" {
  description = "ARN of existing ECR repository (required if create_ecr_repo = false)"
  type        = string
  default     = ""
}

variable "ecr_image_tag_mutability" {
  description = "The tag mutability setting for the ECR repository"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.ecr_image_tag_mutability)
    error_message = "ECR image tag mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "ecr_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

# Elastic Beanstalk variables
variable "beanstalk_app_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
}

variable "beanstalk_env_name" {
  description = "The name of the Elastic Beanstalk environment"
  type        = string
}

variable "beanstalk_solution_stack_name" {
  description = "Solution stack name for Elastic Beanstalk environment"
  type        = string
  # Example: "64bit Amazon Linux 2 v3.4.9 running Docker"
}

variable "beanstalk_tier" {
  description = "Elastic Beanstalk environment tier"
  type        = string
  default     = "WebServer"
  validation {
    condition     = contains(["WebServer", "Worker"], var.beanstalk_tier)
    error_message = "Elastic Beanstalk tier must be either WebServer or Worker."
  }
}

variable "beanstalk_instance_type" {
  description = "Instance type for EC2 instances in the environment"
  type        = string
  default     = "t3.micro"
}

variable "beanstalk_min_instances" {
  description = "Minimum number of instances in the Elastic Beanstalk environment"
  type        = number
  default     = 1
}

variable "beanstalk_max_instances" {
  description = "Maximum number of instances in the Elastic Beanstalk environment"
  type        = number
  default     = 2
}

variable "beanstalk_vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
  default     = null
}

variable "beanstalk_subnets" {
  description = "List of subnet IDs to launch resources in"
  type        = list(string)
  default     = null
}

variable "beanstalk_elb_subnets" {
  description = "List of subnet IDs for the ELB"
  type        = list(string)
  default     = null
}

variable "beanstalk_environment_variables" {
  description = "Map of environment variables for the Elastic Beanstalk environment"
  type        = map(string)
  default     = {}
}

variable "beanstalk_additional_settings" {
  description = "Additional Elastic Beanstalk settings"
  type = list(object({
    namespace = string
    name      = string
    value     = string
  }))
  default = []
}