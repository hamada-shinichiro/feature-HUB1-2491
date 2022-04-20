# common_envが空の場合はDBなどを作りに行かない（DEV全体で共通など）
env        = "prd"
common_env = "prd"

api_ecs_min_capacity = 3
api_ecs_max_capacity = 6

aurora_instance_count = 2

vpc_id = "vpc-073b76ef58b9854be"

subnet-public-a = "subnet-0333c404b5c81bbd6"
subnet-public-c = "subnet-09cbd474bbc8b30a7"
subnet-public-d = "subnet-07f4828d8182fca44"

subnet-protected-a = "subnet-052a068e44d7d519d"
subnet-protected-c = "subnet-057906acd5ba3d7a0"
subnet-protected-d = "subnet-035bc4a8029f2d32e"

subnet-private-a = "subnet-040513dc7db8d5496"
subnet-private-c = "subnet-09f49fc429b2978dc"
subnet-private-d = "subnet-05e91e607bd9b266f"

public-cidr-blocks    = ["10.211.192.0/27", "10.211.192.32/27", "10.211.192.64/27"]
protected-cidr-blocks = ["10.211.192.96/27", "10.211.192.128/27", "10.211.192.160/27"]
private-cidr-blocks   = ["10.211.192.192/27", "10.211.192.224/28", "10.211.192.240/28"]

sg-allow-ingress-any               = "sg-02f392d2e186748ab"
sg-allow-ingress-developer-address = "sg-0ac985239719da38d"
sg-batch                           = "sg-03aa124f83b3fe923"
sg-private                         = ""

domain                         = "7deliveryhub.com"
aws_acm_certificate_validation = "arn:aws:acm:ap-northeast-1:333704318263:certificate/31f4e448-6fd3-4519-8310-95b3cbff95a0"
aws_route53_zone               = "Z07321081QA6PX1JDTIE6"
