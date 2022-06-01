# terraform-aws-ec2-apache
Terraform module which makes it easy to create an Apache web server on an EC2 instance in AWS

Not intended for production use

## Instructions
1. Clone the Repository
```
git clone https://github.com/Jellayy/terraform-aws-ec2-apache.git
```

2. Generate SSH Keys for console access
```
ssh-keygen
```

3. Start spinning up webservers easier than ever
```hcl
provider "aws" {
  region = "us-west-1"
}

module "aws_ec2_apache" {
  source = ".//terraform-aws-ec2-apache"
  server_name = "Very Great Web Server"
  ssh_allowed_ips = "X.X.X.X/X"
  ssh_public_key = "ssh-rsa XXXX"
}

output "web_server_ip" {
  value = module.aws_ec2_apache.ec2_public_ip
}
```

The public IP of your server can be found in terraform's outputs and in the AWS console. Slap the address in your web browser to view the site or use the following commands to access the SSH terminal
```
chmod 400 PRIVATE_KEYFILE

ssh ec2-user@SERVER_IP -i PRIVATE_KEYFILE
```
