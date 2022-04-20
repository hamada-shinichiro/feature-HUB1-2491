# common_envが空の場合はDBなどを作りに行かない（DEV全体で共通など）
env        = "dev2"
common_env = ""

api_ecs_min_capacity = 1
api_ecs_max_capacity = 1

aurora_instance_count = 1

vpc_id = "vpc-0deed925a450ec8a7"

subnet-public-a = "subnet-060981f873070b615"
subnet-public-c = "subnet-08eaee42210e80506"
subnet-public-d = "subnet-04809ed987561a8cd"

subnet-protected-a = "subnet-0d72642e0b5f8abd0"
subnet-protected-c = "subnet-098c7b8dbef681e58"
subnet-protected-d = "subnet-0df8d37411c592215"

subnet-private-a = "subnet-0093060b3d9524834"
subnet-private-c = "subnet-06c4bc89a723b9474"
subnet-private-d = "subnet-01ddf453f032bc538"

public-cidr-blocks    = ["10.212.192.0/27", "10.212.192.32/27", "10.212.192.64/27"]
protected-cidr-blocks = ["10.212.192.96/27", "10.212.192.128/27", "10.212.192.160/27"]
private-cidr-blocks   = ["10.212.192.192/27", "10.212.192.224/28", "10.212.192.240/28"]

sg-allow-ingress-any               = "sg-09859a4f183fbeee2"
sg-allow-ingress-developer-address = "sg-01360652033c00d10"
sg-batch                           = "sg-0acb41873deaccfeb"
sg-private                         = "sg-0c4d4a9fa86323c1c"

domain                         = "dev2.7deliveryhub.com"
aws_acm_certificate_validation = "arn:aws:acm:ap-northeast-1:465414995305:certificate/f0075fb5-30e8-4ea7-a820-e774d5aca93f"
aws_route53_zone               = "Z10409311S8E1393GDI52"
