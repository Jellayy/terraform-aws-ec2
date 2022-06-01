# Grab default VPC from AWS region
data "aws_vpc" "default_vpc" {
  default = true
}

# AWS Security Group to allow HTTP and SSH traffic to server
resource "aws_security_group" "ec2_sg" {
  name        = "sg ${var.server_name}"
  description = "${var.server_name} Security Group"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.ssh_allowed_ips]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups = []
    self = false
  }
}

# AWS key resource for SSH public key
resource "aws_key_pair" "ssh_deployer_key" {
  key_name   = "${var.server_name} Deployer Key"
  public_key = var.ssh_public_key
}

# Cloud-init configuration file to start httpd on server
data "template_file" "httpd_configure" {
  template = file("${path.module}/httpd_configure.yaml")
}

# Get AWS ami in region
data "aws_ami" "ec2_ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# AWS EC2 resource
resource "aws_instance" "ec2_server" {
  ami                    = "${data.aws_ami.ec2_ami.id}"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh_deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data              = data.template_file.httpd_configure.rendered

  tags = {
    Name = var.server_name
  }
}