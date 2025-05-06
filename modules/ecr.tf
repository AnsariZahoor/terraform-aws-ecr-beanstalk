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