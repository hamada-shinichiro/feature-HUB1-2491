################################################################################
# TODO: 重要
# 
# タスク定義を変えた（スペックを変更などした）場合は
# modules/aws_ecs_service の設定を一時的に変える必要があります
#  ->  ignore_changes
################################################################################

#####################################
# CloudWatch Log Settings
#####################################
resource "aws_cloudwatch_log_group" "default" {
  name = "${var.env}-delivery-hub"
  retention_in_days = 180
}

#####################################
# ECS Cluster Settings
#####################################
resource "aws_ecs_cluster" "default" {
  name = "${var.env}-delivery-hub"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

locals {
  ecs_task_name_api = "hub-api"
  ecs_task_name_scheduler = "hub-scheduler"
}

#####################################
# ECS Task Settings
#####################################
module "ecs_task_api" {
  source             = "./modules/aws_ecs_task_hub-api"
  aws_region         = var.aws.region
  env                = var.env
  task_name          = local.ecs_task_name_api
  task_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  repository_url     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${var.env}/delivery-hub/hub-api"
  log_group          = aws_cloudwatch_log_group.default.name
}

module "ecs_task_scheduler" {
  source             = "./modules/aws_ecs_task_hub-scheduler"
  aws_region         = var.aws.region
  env                = var.env
  task_name          = local.ecs_task_name_scheduler
  task_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  repository_url     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${var.env}/delivery-hub/hub-scheduler"
  log_group          = aws_cloudwatch_log_group.default.name
}
