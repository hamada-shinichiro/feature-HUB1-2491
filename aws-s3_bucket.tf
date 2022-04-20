resource "aws_s3_bucket" "lb_log" {
  bucket = "${var.env}-delivery-lb-log-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  lifecycle_rule {
    enabled = true

    expiration {
      days = 400
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lb_log" {
  bucket                  = aws_s3_bucket.lb_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_elb_service_account" "lb_log" {}
data "aws_iam_policy_document" "lb_log" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.lb_log.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.lb_log.id]
    }

  }
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.lb_log.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.lb_log.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "lb_log" {
  bucket = aws_s3_bucket.lb_log.id
  policy = data.aws_iam_policy_document.lb_log.json

  depends_on = [
    aws_s3_bucket_public_access_block.lb_log
  ]
}
