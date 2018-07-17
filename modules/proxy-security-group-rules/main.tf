###############################################################################
#
# Create Security group rules for Proxy service
#
###############################################################################

resource "aws_security_group_rule" "allow_proxy_http_inbound" {
  count       = "${length(var.allowed_http_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.http_port}"
  to_port     = "${var.http_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_http_cidr_blocks}"]

  security_group_id = "${var.security_group_id}"
}

resource "aws_security_group_rule" "allow_proxy_ssh_inbound" {
  count       = "${length(var.allowed_ssh_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.ssh_port}"
  to_port     = "${var.ssh_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_ssh_cidr_blocks}"]
  security_group_id = "${var.security_group_id}"
}
