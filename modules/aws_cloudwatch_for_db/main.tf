variable "env" { type = string }
variable "db_instances" { type = list(string) }

locals {
  db_instance_count = length(var.db_instances)
}

##################################################
# DB Cluster
##################################################
# 無し

##################################################
# DB Instance
##################################################
resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
  count = local.db_instance_count

  alarm_name          = "${var.env}-delivery-db-cpu-${count.index + 1}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  evaluation_periods  = 1
  threshold           = 70
  statistic           = "Average"
  alarm_description   = "Use cpu percentage in Aurora DB"

  dimensions = {
    DBInstanceIdentifier = var.db_instances[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "FreeableMemory" {
  count = local.db_instance_count

  alarm_name          = "${var.env}-delivery-db-freeablememory-${count.index + 1}"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1024 * 1024 * 1024
  statistic           = "Minimum"
  alarm_description   = "Free memory in Aurora DB"

  dimensions = {
    DBInstanceIdentifier = var.db_instances[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "DatabaseConnections" {
  count = local.db_instance_count

  alarm_name          = "${var.env}-delivery-db-connections-${count.index + 1}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  evaluation_periods  = 1
  threshold           = 800
  statistic           = "Maximum"
  alarm_description   = "Number of connections in Aurora DB"

  dimensions = {
    DBInstanceIdentifier = var.db_instances[count.index]
  }
}
resource "aws_cloudwatch_metric_alarm" "BufferCacheHitRatio" {
  count = local.db_instance_count

  alarm_name          = "${var.env}-delivery-db-cachehitratio-${count.index + 1}"
  comparison_operator = "LessThanThreshold"
  metric_name         = "BufferCacheHitRatio"
  namespace           = "AWS/RDS"
  period              = 300
  evaluation_periods  = 1
  threshold           = 90
  statistic           = "Minimum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Free memory percentage in Aurora DB"

  dimensions = {
    DBInstanceIdentifier = var.db_instances[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "CommitLatency" {
  count = local.db_instance_count

  alarm_name          = "${var.env}-delivery-db-commitlatency-${count.index + 1}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CommitLatency"
  namespace           = "AWS/RDS"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  statistic           = "Maximum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Max commit latency in Aurora DB"

  dimensions = {
    DBInstanceIdentifier = var.db_instances[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "AuroraReplicaLag" {
  count = local.db_instance_count

  alarm_name          = "${var.env}-delivery-db-replicalag-${count.index + 1}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "AuroraReplicaLag"
  namespace           = "AWS/RDS"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1000
  statistic           = "Maximum"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Max replica lag in Aurora DB"

  dimensions = {
    DBInstanceIdentifier = var.db_instances[count.index]
  }
}
