resource "aws_security_group" "database" {
  name        = "${var.prefix}-database"
  description = "Control database inbound and outbound access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 27017
    to_port     = 27017

    security_groups = [
      aws_security_group.nodejs.id
    ]

  }

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    security_groups = [
      aws_security_group.bastion.id
    ]
  }


  tags = local.common_tags
}

resource "aws_security_group" "nodejs" {
  name        = "${var.prefix}-nodejs"
  description = "Control nodejs inbound and outbound access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000

    security_groups = [
      aws_security_group.bastion.id
    ]

  }

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    security_groups = [
      aws_security_group.bastion.id
    ]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8081
    to_port     = 8081

    security_groups = [
      aws_security_group.bastion.id
    ]

  }

  tags = local.common_tags
}

resource "aws_security_group" "bastion" {
  name        = "${var.prefix}-bastion"
  description = "Control bastion inbound and outbound access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
