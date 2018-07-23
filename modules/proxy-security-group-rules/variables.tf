###############################################################################
# REQUIRED VARIABLES
###############################################################################
variable "allowed_ssh_cidr_blocks" {
  description = "The CIDR blocks allowed to SSH to the instance."
  type        = "list"
}

variable "allowed_http_cidr_blocks" {
  description = "The CIDR blocks allowed to make HTTP connections."
  type        = "list"
}

variable "security_group_id" {
  description = "The ID of the security group with which to associate the security group rules"
}

###############################################################################
# DEFAULT VARIABLES
###############################################################################

variable "http_port" {
  description = "The port for http protocols. Usually 80"
  default = "80"
}

variable "ssh_port" {
  description = "The port with which to connect through ssh. Usually 22"
  default = "22"
}
