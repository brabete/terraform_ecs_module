output "cluster_name" {
  value = "${aws_ecs_cluster.cluster.name}"
}

output "ecs_host_role_arn" {
  value = "${aws_iam_role.ecs_host_role.arn}"
}

output "ecs_host_role" {
  value = "${aws_iam_role.ecs_host_role.name}"
}
