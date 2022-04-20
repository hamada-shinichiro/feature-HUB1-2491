# https://www.terraform.io/docs/configuration/variables.html
variable "env" { type = string }
variable "common_env" { type = string }

variable "aws" {
  type = map(any)
  default = {
    region = "ap-northeast-1"
  }
}

variable "api_ecs_min_capacity" { type = number }
variable "api_ecs_max_capacity" { type = number }
variable "scheduler_ecs_min_capacity" { type = number }
variable "scheduler_ecs_max_capacity" { type = number }
variable "aurora_instance_count" { type = number }

variable "domain" { type = string }

variable "vpc_id" { type = string }

variable "subnet-public-a" { type = string }
variable "subnet-public-c" { type = string }
variable "subnet-public-d" { type = string }

variable "subnet-protected-a" { type = string }
variable "subnet-protected-c" { type = string }
variable "subnet-protected-d" { type = string }

variable "subnet-private-a" { type = string }
variable "subnet-private-c" { type = string }
variable "subnet-private-d" { type = string }

variable "public-cidr-blocks" { type = list(string) }
variable "protected-cidr-blocks" { type = list(string) }
variable "protected-cidr-blocks-common" { type = list(string) }
variable "private-cidr-blocks" { type = list(string) }

variable "sg-allow-ingress-any" { type = string }
variable "sg-allow-ingress-developer-address" { type = string }
variable "sg-batch" { type = string }
variable "sg-private" { type = string }


variable "aws_acm_certificate_validation" { type = string }
variable "aws_route53_zone" { type = string }

variable "lb_idle_timeout" { default = 80 }

