###############################################################################
#
# Create Security group rules for Proxy service
#
###############################################################################

resource "aws_security_group_rule" "allow_proxy_https_inbound" {
  count       = "${length(var.allowed_https_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.https_port}"
  to_port     = "${var.https_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_https_cidr_blocks}"]

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


resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${var.security_group_id}"
}
