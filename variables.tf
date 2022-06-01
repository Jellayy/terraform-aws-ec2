variable "server_name" {
  type = string
  description = "Name for the server"
  default = "Apache Web Server"
}

variable "ssh_allowed_ips" {
  type = string
  description = "CIDR notated IPV4 address block to allow SSH connections on. EX: 154.23.5.4/32 OR 50.34.2.0/16"
}

variable "ssh_public_key" {
  type = string
  description = "Public key used to authenticate SSH sessions"
}

variable "instance_type" {
  type = string
  description = "Size of the server you want to deploy"
  default = "t2.micro"
}