data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "server1" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.public_a.id
  key_name             = var.server_key_name

  vpc_security_group_ids = [
    aws_security_group.server1.id
  ]

  tags = merge(
    local.common_tags,
    tomap({"Name" = "${var.prefix}-server1"}),
    tomap({"ansible" = "accept"})
  )
  #provisioner "local-exec" {
   # working_dir = "/home/omar/nodejs-devops/ansible/"
    #command = "ansible-playbook --inventory ${self.public_ip}, --private-key ${var.private_key} --user ec2-user docker.yaml"
  #}
}

resource "aws_security_group" "server1" {
  name        = "${var.prefix}-server1"
  description = "Control server1 inbound and outbound access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 50000
    to_port     = 50000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

output "instance_public_ip_address" {
  value       = aws_instance.server1.public_ip
  description = "The public IP address of the main server instance."
}