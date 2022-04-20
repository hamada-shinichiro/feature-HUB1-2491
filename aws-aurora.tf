resource "aws_db_subnet_group" "main" {
  count = var.common_env == "" ? 0 : 1

  name       = "${var.common_env}-subnet-delihub"
  subnet_ids = [var.subnet-private-a, var.subnet-private-c, var.subnet-private-d]
}

resource "aws_rds_cluster_parameter_group" "main" {
  count = var.common_env == "" ? 0 : 1

  name        = "${var.common_env}-db-delihub"
  family      = "aurora-postgresql12"
  description = "${var.common_env}-db-delihub"

  parameter {
    apply_method = "immediate"
    name         = "log_min_duration_statement"
    value        = 1000
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.log"
    value        = "all"
  }
  parameter {
    apply_method = "immediate"
    name         = "timezone"
    value        = "asia/tokyo"
  }
}

resource "aws_db_parameter_group" "main" {
  count = var.common_env == "" ? 0 : 1

  name        = "${var.common_env}-db-delihub"
  family      = "aurora-postgresql12"
  description = "${var.common_env}-db-delihub"
}

resource "aws_rds_cluster" "default" {
  count = var.common_env == "" ? 0 : 1

  cluster_identifier              = "${var.common_env}-db-delihub"
  engine                          = "aurora-postgresql"
  engine_version                  = "12.4"
  availability_zones              = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  database_name                   = "${var.common_env}delihub"
  master_username                 = "postgres"
  master_password                 = "postgrespass" #一時的な値。terratarm反映後、コンソールから手動で変更する。
  db_subnet_group_name            = aws_db_subnet_group.main.0.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.0.name
  vpc_security_group_ids          = [var.sg-private == "" ? aws_security_group.private-internal-traffic.0.id : var.sg-private]
  final_snapshot_identifier       = "${var.common_env}-delihub-db-final-snapshot"
  skip_final_snapshot             = false
  storage_encrypted               = true
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  preferred_backup_window         = "19:30-20:00"
  preferred_maintenance_window    = "mon:17:00-mon:17:30"
  backup_retention_period         = 7

  lifecycle {
    ignore_changes = [
      master_password,
    ]
  }
}

resource "aws_rds_cluster_instance" "db" {
  count = var.common_env == "" ? 0 : var.aurora_instance_count

  apply_immediately            = true
  cluster_identifier           = aws_rds_cluster.default.0.id
  identifier                   = "${var.common_env}-db-delihub-${count.index + 1}"
  instance_class               = "db.r5.large"
  engine                       = aws_rds_cluster.default.0.engine
  engine_version               = aws_rds_cluster.default.0.engine_version
  db_subnet_group_name         = aws_db_subnet_group.main.0.name
  db_parameter_group_name      = aws_db_parameter_group.main.0.name
  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_arn          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/rds-monitoring-role"
}
