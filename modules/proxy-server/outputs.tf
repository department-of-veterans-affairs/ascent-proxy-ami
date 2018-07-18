output "security_group_id" {
  value = "${aws_security_group.proxy_security_group.id}"
}


output "private_ip" {
  value = "${aws_instance.proxy_instance.private_ip}"
}

output "http_port" {
  value = "${module.security_group_rules.http_port}"
}
