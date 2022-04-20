module "alb_internal_api" {
  source      = "./modules/aws_lb_internal"
  env         = var.env
  target_name = "hub-api"
  zone_id     = var.aws_route53_zone
  vpc_id      = var.vpc_id

  subnets = [
    var.subnet-protected-a,
    var.subnet-protected-c,
    var.subnet-protected-d
  ]

  elb_security_group_ids = [
    var.sg-allow-ingress-any,
    var.sg-allow-ingress-developer-address,
    aws_security_group.public-internal-traffic.id,
    aws_security_group.ecs-internal-traffic.id
  ]

  certificate_arn = var.aws_acm_certificate_validation
  domain_name     = "internal-hub-api.${var.domain}"
  idle_timeout    = var.lb_idle_timeout
  bucket_id       = aws_s3_bucket.lb_log.id
}
