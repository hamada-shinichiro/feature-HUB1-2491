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
resource "aws_lb" "default" {
  name                       = "${var.env}-delivery-${var.target_name}"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = false

  subnets         = var.subnets
  security_groups = var.elb_security_group_ids

  access_logs {
    bucket  = var.bucket_id
    prefix  = var.target_name
    enabled = true
  }

  tags = {
    Name        = "${var.env}-delivery-${var.target_name}"
    Environment = var.env
    BuildedBy   = "terraform"
  }
}

#####################################
# ALB Target Settings
#####################################
resource "aws_lb_target_group" "default" {
  name        = "${var.env}-delivery-${var.target_name}"
  vpc_id      = var.vpc_id
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    path = var.health_check_path
  }

  tags = {
    Name        = "${var.env}-delivery-${var.target_name}"
    Environment = var.env
    BuildedBy   = "terraform"
  }
}

#####################################
# ALB Listener Settings
#####################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.default.arn
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

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.default.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }
}


#####################################
# DNS Settings
#####################################
resource "aws_route53_record" "default" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.default.dns_name
    zone_id                = aws_lb.default.zone_id
    evaluate_target_health = true
  }
}

output "lb_arn" {
  value = aws_lb.default.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.default.arn
}

output "target_group" {
  value = aws_lb_target_group.default.arn_suffix
}

output "load_balancer" {
  value = aws_lb.default.arn_suffix
}
