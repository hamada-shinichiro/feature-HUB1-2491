variable "aws_region" {}
variable "env" {}
variable "task_name" {}
variable "cpu" { default = 2048 }
variable "memory" { default = 4096 }
variable "task_role_arn" {}
variable "execution_role_arn" {}
variable "repository_url" {}
variable "log_group" {}

locals {
  template_file_path = "${path.module}/tasks/${var.task_name}.json"
}

#####################################
# ECS Tasks Settings
#####################################
data "template_file" "default" {
  template = file(local.template_file_path)

  vars = {
    aws_region     = var.aws_region
    env            = var.env
    task_name      = var.task_name
    repository_url = var.repository_url
    log_group      = var.log_group
  }
}

resource "aws_ecs_task_definition" "default" {
  family                   = "${var.env}-delivery-${var.task_name}"
  container_definitions    = data.template_file.default.rendered
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.default.arn
}
