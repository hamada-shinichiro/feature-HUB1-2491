module "alb_external_api" {
  source      = "./modules/aws_lb_external_api"
  env         = var.env
  target_name = "hub-api"
  zone_id     = var.aws_route53_zone
  vpc_id      = var.vpc_id

  subnets = [
    var.subnet-public-a,
    var.subnet-public-c,
    var.subnet-public-d
  ]

  elb_security_group_ids = [
    var.sg-allow-ingress-any,
    var.sg-allow-ingress-developer-address,
    aws_security_group.public-internal-traffic.id
  ]

  certificate_arn = var.aws_acm_certificate_validation
  domain_name     = "api.${var.domain}"
  idle_timeout    = var.lb_idle_timeout
  bucket_id       = aws_s3_bucket.lb_log.id
}

module "alb_external_scheduler" {
  source      = "./modules/aws_lb_external_scheduler"
  env         = var.env
  target_name = "hub-scheduler"
  zone_id     = var.aws_route53_zone
  vpc_id      = var.vpc_id

  subnets = [
    var.subnet-public-a,
    var.subnet-public-c,
    var.subnet-public-d
  ]

  elb_security_group_ids = [
    var.sg-allow-ingress-any,
    var.sg-allow-ingress-developer-address,
    aws_security_group.public-internal-traffic.id
  ]

  certificate_arn = var.aws_acm_certificate_validation
  domain_name     = "scheduler.${var.domain}"
  idle_timeout    = var.lb_idle_timeout
  bucket_id       = aws_s3_bucket.lb_log.id
}
