output "task_role_arn" {
  value = "${aws_iam_role.main.arn}"
}

output "ecr_repository_url" {
  value = "${module.ecr_repo.repository_url}"
}

output "task_arn" {
  value = "${aws_ecs_task_definition.task.arn}"
}

output "container_port" {
  value = "${var.container_port}"
}

output "application_name" {
  value = "${var.name}"
}

output "log_group" {
  value = "${var.ecs_log_group}"
}

output "log_retention" {
  value = "${var.log_retention}"
}

output "family" {
  value = "${aws_ecs_task_definition.task.family}"
}

output "revision" {
  value = "${aws_ecs_task_definition.task.revision}"
}
