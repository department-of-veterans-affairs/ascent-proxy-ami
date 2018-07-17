###############################################################################
# REQUIRED VARIABLES
###############################################################################
variable "ami_id" {
  description = "The ID of the AMI to start this EC2 instance as."
}
variable "ssh_key_name" {
  description = "The name of the ssh key that will connect with the instance"
}
variable "subnet_id" {
  description = "The subnet ID to launch the EC2 instance into."
}
variable "vpc_id" {
  description = "The ID of the VPC to launch the security group into"
}
variable "instance_name" {
  description = "The name of the instance and other resources associated with it"
}
variable "san"{
  description = "The SAN tag of the instance that the DNS server uses to create a DNS for the instance."
}
variable "allowed_ssh_cidr_blocks" {
  description = "The CIDR blocks allowed SSH access to the instance"
}
variable "allowed_http_cidr_blocks" {
  description = "The CIDR blocks allowed HTTP access to the instance"
}
variable "server_name" {
  description = "The name of the virtual server on the proxy instance"
}
variable "location" {
  description = "The location on the proxy path that will be passed on to the backend server"
}
variable "proxy_pass" {
  description = "The URL of the backend server to pass the proxy path to."
}



###############################################################################
# DEFAULT VARIABLES
###############################################################################
variable "instance_type" {
  description = "The type of the EC2 instance (m4.large, t2.micro, etc)"
  default     = "t2.micro"
}
variable "associate_public_ip_address" {
  description = "Specify whether you want to associate a public IP address with the EC2 instance. Default is false"
  default     = "false"
}
variable "aws_security_group_ids" {
  description = "A list of security group IDs to allow inbound/outbound traffic to the instance."
  default     = []
  type        = "list"
}
variable "user_data" {
  description = "The user data to run on the instance. If left blank, will run user data provided by the template"
  default     = ""
}
