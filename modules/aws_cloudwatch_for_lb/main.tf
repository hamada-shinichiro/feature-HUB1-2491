variable "env" { type = string }
variable "target_name" { type = string }
variable "threshold" { type = number }
variable "target_group" { type = string }
variable "load_balancer" { type = string }
variable "idle_timeout" { type = number }

resource "aws_cloudwatch_metric_alarm" "HealthyHostCount" {
  alarm_name          = "${var.env}-delivery-${var.target_name}-alb-healthyhosts"
  comparison_operator = "LessThanThreshold"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.threshold
  statistic           = "Minimum"
  alarm_description   = "Number of healthy nodes in Target Group"
  # actions_enabled     = true
  # alarm_actions       = [aws_sns_topic.sns.arn]
  # ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = var.target_group
    LoadBalancer = var.load_balancer
  }
}

resource "aws_cloudwatch_metric_alarm" "TargetConnectionErrorCount" {
  alarm_name          = "${var.env}-delivery-${var.target_name}-alb-connectionerrors"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "TargetConnectionErrorCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Number of Connection error nodes in Target Group"
  # actions_enabled     = true
  # alarm_actions       = [aws_sns_topic.sns.arn]
  # ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = var.target_group
    LoadBalancer = var.load_balancer
  }
}

resource "aws_cloudwatch_metric_alarm" "RejectedConnectionCount" {
  alarm_name          = "${var.env}-delivery-${var.target_name}-alb-rejectedconnections"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "RejectedConnectionCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Number of Rejected Connection nodes in Target Group"
  # actions_enabled     = true
  # alarm_actions       = [aws_sns_topic.sns.arn]
  # ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = var.target_group
    LoadBalancer = var.load_balancer
  }
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_Target_5XX_Count" {
  alarm_name          = "${var.env}-delivery-${var.target_name}-alb-target-5xxcount"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Number of Target 5xx count nodes in Target Group"
  # actions_enabled     = true
  # alarm_actions       = [aws_sns_topic.sns.arn]
  # ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = var.target_group
    LoadBalancer = var.load_balancer
  }
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_ELB_5XX_Count" {
  alarm_name          = "${var.env}-delivery-${var.target_name}-alb-5xxcount"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Number of ELB 5xx count nodes in Target Group"
  # actions_enabled     = true
  # alarm_actions       = [aws_sns_topic.sns.arn]
  # ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    LoadBalancer = var.load_balancer
  }
}

resource "aws_cloudwatch_metric_alarm" "TargetResponseTime" {
  alarm_name          = "${var.env}-delivery-${var.target_name}-alb-responsetime"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.idle_timeout
  statistic           = "Maximum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Max response time in Target Group"
  # actions_enabled     = true
  # alarm_actions       = [aws_sns_topic.sns.arn]
  # ok_actions          = [aws_sns_topic.sns.arn]
  dimensions = {
    TargetGroup  = var.target_group
    LoadBalancer = var.load_balancer
  }
}
