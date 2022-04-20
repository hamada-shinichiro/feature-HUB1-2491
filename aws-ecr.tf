# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository
resource "aws_ecr_repository" "hub-api" {
  name                 = "${var.env}/delivery-hub/hub-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository" "hub-scheduler" {
  name                 = "${var.env}/delivery-hub/hub-scheduler"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository" "sorry-page" {
  name                 = "${var.env}/delivery-hub/sorry-page"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

locals {
  ecr_poilcy = jsonencode(
    {
      "rules" : [
        {
          "rulePriority" : 1,
          "description" : "Expire old images",
          "selection" : {
            "tagStatus" : "untagged",
            "countType" : "sinceImagePushed",
            "countUnit" : "days",
            "countNumber" : 1
          },
          "action" : {
            "type" : "expire"
          }
        }
      ]
    }
  )
}

resource "aws_ecr_lifecycle_policy" "hub-api" {
  repository = aws_ecr_repository.hub-api.name
  policy     = local.ecr_poilcy
}

resource "aws_ecr_lifecycle_policy" "hub-scheduler" {
  repository = aws_ecr_repository.hub-scheduler.name
  policy     = local.ecr_poilcy
}

resource "aws_ecr_lifecycle_policy" "sorry-page" {
  repository = aws_ecr_repository.sorry-page.name
  policy     = local.ecr_poilcy
}
