variable "env" {}
variable "target_name" {}
variable "zone_id" {}
variable "vpc_id" {}
variable "subnets" { type = list(string) }
variable "elb_security_group_ids" {}
variable "certificate_arn" {}
variable "domain_name" {}
variable "health_check_path" { default = "/deliveryhub/health" }
variable "idle_timeout" { type = number }
variable "bucket_id" {}


#####################################
# ALB Settings
#####################################
resource "aws_lb" "lb-internal-hub-api" {
  name                       = "${var.env}-in-delivery-hub-api"
  load_balancer_type         = "application"
  internal                   = true
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = false

  subnets         = var.subnets
  security_groups = var.elb_security_group_ids

  access_logs {
    bucket  = var.bucket_id
    prefix  = "internal-hub-api"
    enabled = true
  }

  tags = {
    Name        = "internal-hub-api"
    Environment = var.env
    BuildedBy   = "terraform"
  }
}

#####################################
# ALB Target Settings
#####################################
resource "aws_lb_target_group" "lb-internal-hub-api" {
  name        = "${var.env}-in-delivery-hub-api"
  vpc_id      = var.vpc_id
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    path = var.health_check_path
  }

  tags = {
    Name        = "${var.env}-in-delivery-hub-api"
    Environment = var.env
    BuildedBy   = "terraform"
  }
}

#####################################
# ALB Listener Settings
#####################################
resource "aws_lb_listener" "http-lb-internal" {
  load_balancer_arn = aws_lb.lb-internal-hub-api.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https-lb-internal" {
  load_balancer_arn = aws_lb.lb-internal-hub-api.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.lb-internal-hub-api.arn
    type             = "forward"
  }
}

#####################################
# DNS Settings
#####################################
resource "aws_route53_record" "lb-internal-hub-api" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.lb-internal-hub-api.dns_name
    zone_id                = aws_lb.lb-internal-hub-api.zone_id
    evaluate_target_health = true
  }
}

output "lb_arn" {
  value = aws_lb.lb-internal-hub-api.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.lb-internal-hub-api.arn
}

output "target_group" {
  value = aws_lb_target_group.lb-internal-hub-api.arn_suffix
}

output "load_balancer" {
  value = aws_lb.lb-internal-hub-api.arn_suffix
}
