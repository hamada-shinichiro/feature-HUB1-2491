# ECS

locals {

  ecs_service_delivery-hub-api_definitions = [
    "hub-api",
  ]

  ecs_service_delivery-hub-scheduler_definitions = [
    "hub-scheduler",
  ]
}

#####################################
# ECS Service Settings
#####################################
resource "aws_ecs_service" "hub-api" {
  for_each = toset(local.ecs_service_delivery-hub-api_definitions)
  name                              = "${var.env}-delivery-${each.value}"
  cluster                           = aws_ecs_cluster.default.id
  task_definition                   = module.ecs_task_api.task_definition_arn
  desired_count                     = var.api_ecs_min_capacity
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60

  load_balancer {
    target_group_arn = module.alb_external_api.target_group_arn
    container_name   = each.value
    container_port   = 8080
  }

  load_balancer {
    target_group_arn = module.alb_internal_api.target_group_arn
    container_name   = each.value
    container_port   = 8080
  }

  network_configuration {
    subnets          = [var.subnet-protected-a, var.subnet-protected-c, var.subnet-protected-d]
    security_groups  = [aws_security_group.protected-internal-traffic.id]
    assign_public_ip = false
  }

  # TODO: スペックを変えた際はこの設定を無効化にしてビルド
  lifecycle {
    ignore_changes = [task_definition]
  }
  depends_on = [module.ecs_task_api, module.alb_external_api, module.alb_internal_api, aws_security_group.protected-internal-traffic]
}

resource "aws_ecs_service" "hub-scheduler" {
  for_each = toset(local.ecs_service_delivery-hub-scheduler_definitions)
  name                              = "${var.env}-delivery-${each.value}"
  cluster                           = aws_ecs_cluster.default.id
  task_definition                   = module.ecs_task_scheduler.task_definition_arn
  desired_count                     = 0
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60

  load_balancer {
    target_group_arn = module.alb_external_scheduler.target_group_arn
    container_name   = each.value
    container_port   = 8080
  }

  network_configuration {
    subnets          = [var.subnet-protected-a, var.subnet-protected-c, var.subnet-protected-d]
    security_groups  = [aws_security_group.protected-internal-traffic.id]
    assign_public_ip = false
  }

  # TODO: スペックを変えた際はこの設定を無効化にしてビルド
  lifecycle {
    ignore_changes = [task_definition]
  }
  depends_on = [module.ecs_task_scheduler, module.alb_external_scheduler, aws_security_group.protected-internal-traffic]
}

#####################################
# cloudwatch Setting
#####################################
resource "aws_cloudwatch_metric_alarm" "service_sacle_out_hub-api" {
  for_each = toset(local.ecs_service_delivery-hub-api_definitions)
  alarm_name          = "${aws_ecs_cluster.default.name}-ECSService-CPU-Utilization-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 60

  dimensions = {
    ClusterName = aws_ecs_cluster.default.name
    ServiceName = aws_ecs_service.hub-api[each.value].name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_out[each.value].arn]
}

resource "aws_cloudwatch_metric_alarm" "service_sacle_in_hub-api" {
  for_each = toset(local.ecs_service_delivery-hub-api_definitions)
  alarm_name          = "${aws_ecs_cluster.default.name}-ECSService-CPU-Utilization-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    ClusterName = aws_ecs_cluster.default.name
    ServiceName = aws_ecs_service.hub-api[each.value].name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_in[each.value].arn]
}

#####################################
# ECS Service Auto Scale Setting
#####################################
resource "aws_appautoscaling_target" "default" {
  for_each = toset(local.ecs_service_delivery-hub-api_definitions)
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.default.name}/${aws_ecs_service.hub-api[each.value].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  # role_arn           = data.aws_iam_role.ecs_service_autoscaling.arn
  min_capacity = var.api_ecs_min_capacity
  max_capacity = var.api_ecs_max_capacity
}

resource "aws_appautoscaling_policy" "scale_out" {
  for_each = toset(local.ecs_service_delivery-hub-api_definitions)
  name               = "scale-out"
  resource_id        = "service/${aws_ecs_cluster.default.name}/${aws_ecs_service.hub-api[each.value].name}"
  scalable_dimension = aws_appautoscaling_target.default[each.value].scalable_dimension
  service_namespace  = aws_appautoscaling_target.default[each.value].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.default]
}

resource "aws_appautoscaling_policy" "scale_in" {
  for_each = toset(local.ecs_service_delivery-hub-api_definitions)
  name               = "scale-in"
  resource_id        = "service/${aws_ecs_cluster.default.name}/${aws_ecs_service.hub-api[each.value].name}"
  scalable_dimension = aws_appautoscaling_target.default[each.value].scalable_dimension
  service_namespace  = aws_appautoscaling_target.default[each.value].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.default]
}
