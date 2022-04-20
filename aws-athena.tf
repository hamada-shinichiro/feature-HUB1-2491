resource "aws_athena_database" "alb_logs" {
  name   = "${var.env}_alb_logs"
  bucket = aws_s3_bucket.lb_log.bucket
}
