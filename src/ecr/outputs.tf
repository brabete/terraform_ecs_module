output "repository_url" {
  value = "${aws_ecr_repository.main.repository_url}"
}

output "repository_arn" {
  value = "${aws_ecr_repository.main.arn}"
}

output "readonly_policy_arn" {
  value = "${aws_iam_policy.readonly_policy.arn}"
}

output "readwrite_policy_arn" {
  value = "${aws_iam_policy.write_policy.arn}"
}

output "push_policy_arn" {
  value = "${aws_iam_policy.push_policy.arn}"
}
