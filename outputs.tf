output "ec2_public_ip" {
  value = aws_instance.ec2_server.public_ip
  description = "Public IP address of the EC2 Apache webserver used for HTML and SSH access"
}