########################################################################################################################################################################################################################
#
# Creates an nginx proxy server with associated security groups to proxy a web server
#
########################################################################################################################################################################################################################

# ---------------------------------------------------------------------------------------------------------------------
# THESE TEMPLATES REQUIRE TERRAFORM VERSION 0.8 AND ABOVE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.9.3"
}

resource "aws_instance" "proxy_instance" {
  instance_type         = "${var.instance_type}"
  ami                   = "${var.ami_id}"
  key_name              = "${var.ssh_key_name}"
  subnet_id             = "${var.subnet_id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  vpc_security_group_ids = ["${aws_security_group.proxy_security_group.id}", "${var.aws_security_group_ids}"]
  user_data              = "${var.user_data == "" ? data.template_file.proxy_user_data.rendered : var.user_data}"
  tags {
    Name = "${var.instance_name}"
    SAN = "${var.san}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Control Traffic to Proxy Instance
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "proxy_security_group" {
  name_prefix = "${var.instance_name}"
  description = "Security group for the ${var.instance_name} instance"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.instance_name}"
  }
}

module "security_group_rules" {
  source = "../proxy_security_group_rules"
  security_group_id = "${aws_security_group.proxy_security_group.id}"
  allowed_ssh_cidr_blocks = ["${var.allowed_ssh_cidr_blocks}"]
  allowed_http_cidr_blocks = ["${var.allowed_http_cidr_blocks}"]
}

# ---------------------------------------------------------------------------------------------------------------------
# Default User Data script
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "proxy_user_data" {
  template = "${file("${path.module}/proxy-user-data.sh")}"

  vars {
    server_name       = "${var.server_name}"
    location          = "${var.location}"
    proxy_pass        = "${var.proxy_pass}"
  }
}
