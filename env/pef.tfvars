# common_envが空の場合はDBなどを作りに行かない（DEV全体で共通など）
env        = "pef"
common_env = "pef"

api_ecs_min_capacity = 3
api_ecs_max_capacity = 6

scheduler_ecs_min_capacity = 1
scheduler_ecs_max_capacity = 1

aurora_instance_count = 2

vpc_id = "vpc-0deed925a450ec8a7"

subnet-public-a = "subnet-0daafc61d8931a8e4"
subnet-public-c = "subnet-0ec014c14b9ad1cb7"
subnet-public-d = "subnet-03ad9dae102cbf60d"

subnet-protected-a = "subnet-070c4841d20766ab4"
subnet-protected-c = "subnet-07cd4218c41334bc9"
subnet-protected-d = "subnet-0df26dc16b75082a2"

subnet-private-a = "subnet-0093060b3d9524834"
subnet-private-c = "subnet-06c4bc89a723b9474"
subnet-private-d = "subnet-01ddf453f032bc538"

public-cidr-blocks           = ["10.212.195.0/28", "10.212.195.16/28", "10.212.195.32/28"]
protected-cidr-blocks        = ["10.212.195.64/27", "10.212.195.96/27", "10.212.195.128/27"]
protected-cidr-blocks-common = ["10.212.192.96/27", "10.212.192.128/27", "10.212.192.160/27", "10.212.195.64/27", "10.212.195.96/27", "10.212.195.128/27"]
private-cidr-blocks          = ["10.212.192.192/27", "10.212.192.224/28", "10.212.192.240/28"]

sg-allow-ingress-any               = "sg-09859a4f183fbeee2"
sg-allow-ingress-developer-address = "sg-01360652033c00d10"
sg-batch                           = "sg-0acb41873deaccfeb"
sg-private                         = ""

domain                         = "pef.7deliveryhub.com"
aws_acm_certificate_validation = "arn:aws:acm:ap-northeast-1:465414995305:certificate/5816deea-55c4-4171-8cdc-475dac41790b"
aws_route53_zone               = "Z09746802VSXNJ63ADL6R"
