###############################################################################
# REQUIRED VARIABLES
###############################################################################
variable "allowed_ssh_cidr_blocks" {
  description = "The CIDR blocks allowed to SSH to the instance."
  type        = "list"
}

variable "allowed_https_cidr_blocks" {
  description = "The CIDR blocks allowed to make HTTPS connections."
  type        = "list"
}

variable "security_group_id" {
  description = "The ID of the security group with which to associate the security group rules"
}

###############################################################################
# DEFAULT VARIABLES
###############################################################################

variable "https_port" {
  description = "The port for https protocols. Usually 443"
  default = "443"
}

variable "ssh_port" {
  description = "The port with which to connect through ssh. Usually 22"
  default = "22"
}
