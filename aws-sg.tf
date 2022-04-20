resource "aws_security_group" "public-internal-traffic" {
  name        = "${var.env}-public-internal-traffic"
  description = "public subnet security group."
  vpc_id      = var.vpc_id

  egress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    security_groups = [
      aws_security_group.protected-internal-traffic.id
    ]
  }

  lifecycle {
    # ignore_changes = [egress]
  }

  tags = {
    Name = "public-inetrnal-traffic"
  }
}

resource "aws_security_group" "protected-internal-traffic" {
  name        = "${var.env}-protected-internal-traffic"
  description = "protected subnet security group."
  vpc_id      = var.vpc_id

  ingress {
    description = "subnet public a/b/c"
    cidr_blocks = var.public-cidr-blocks
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "subnet public a/b/c"
    cidr_blocks = var.public-cidr-blocks
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  ingress {
    description = "subnet protected a/b/c"
    cidr_blocks = var.protected-cidr-blocks
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "subnet protected a/b/c"
    cidr_blocks = var.protected-cidr-blocks
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
  }

  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.sg-private == "" ? aws_security_group.private-internal-traffic.0.id : var.sg-private]
  }

  lifecycle {
    ignore_changes = [egress]
  }

  tags = {
    Name = "protected-inetrnal-traffic"
  }
}

resource "aws_security_group" "private-internal-traffic" {
  count = var.sg-private == "" ? 1 : 0

  name        = "${var.common_env}-private-internal-traffic"
  description = "private subnet security group."
  vpc_id      = var.vpc_id

  ingress {
    description = "subnet protected a/b/c"
    cidr_blocks = var.protected-cidr-blocks-common
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  lifecycle {
    # ignore_changes = [ingress]
  }

  tags = {
    Name = "private-inetrnal-traffic"
  }
}

resource "aws_security_group" "ecs-internal-traffic" {
  name        = "${var.env}-ecs-internal-traffic"
  description = "ecs-internal-traffic."
  vpc_id      = var.vpc_id

  ingress {
    description = "ECS communication"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    security_groups = [
      aws_security_group.protected-internal-traffic.id
    ]
  }

  lifecycle {
    # ignore_changes = [ingress]
  }

  tags = {
    Name = "ecs-internal-traffic"
  }
}
