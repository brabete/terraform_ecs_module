output "target_group_arn" {
  value = "${aws_alb_target_group.main.arn}"
}

output "alb" {
  value = "${aws_alb.main.name}"
}

output "alb_arn" {
  value = "${aws_alb.main.arn}"
}

output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "internal_dns" {
  value = "${aws_route53_record.internal_dns_record.fqdn}"
}

output "external_dns" {
  value = "${aws_route53_record.external_dns_record.fqdn}"
}
