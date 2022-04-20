module "cloudwatch_api" {
  source        = "./modules/aws_cloudwatch_for_lb"
  env           = var.env
  target_name   = "api"
  threshold     = var.api_ecs_min_capacity
  target_group  = module.alb_external_api.target_group
  load_balancer = module.alb_external_api.load_balancer
  idle_timeout  = var.lb_idle_timeout
}

module "cloudwatch_scheduler" {
  source        = "./modules/aws_cloudwatch_for_lb"
  env           = var.env
  target_name   = "scheduler"
  threshold     = var.scheduler_ecs_min_capacity
  target_group  = module.alb_external_scheduler.target_group
  load_balancer = module.alb_external_scheduler.load_balancer
  idle_timeout  = var.lb_idle_timeout
}

module "cloudwatch_db" {
  count = var.common_env == "" ? 0 : 1

  source       = "./modules/aws_cloudwatch_for_db"
  env          = var.common_env
  db_instances = aws_rds_cluster_instance.db.*.identifier
}
