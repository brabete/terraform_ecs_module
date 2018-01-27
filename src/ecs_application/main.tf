data "template_file" "assume_role" {
  template = "${file("${path.module}/policies/task_role.json")}"
}

resource "aws_iam_role" "main" {
  assume_role_policy = "${data.template_file.assume_role.rendered}"
  name = "${var.name}-ecs-task-role"
}

module "ecr_repo" {
  source = "../ecr"
  aws_region = "${var.aws_region}"
  name = "${var.name}"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "${var.ecs_log_group}"
  retention_in_days = "${var.log_retention}"
  count = "${var.ecs_log_group == "" ? 0 : 1}"
}

data "template_file" "task" {
  template = "${file("${path.module}/tasks/${var.template}.json.tpl")}"
  vars {
    name = "${var.name}"
    image = "${format("%s:%s", module.ecr_repo.repository_url, var.version)}"
    cpu = "${var.cpu}"
    memory = "${var.memory}"
    node_env = "${var.node_env}"
    node_mongodb = "${var.node_mongodb}"
    application_port = "${var.container_port}"
    ecs_log_group = "${var.ecs_log_group}"
    aws_log_region = "${var.aws_log_region}"
    node_solr_hostname = "${var.node_solr_hostname}"
    splunk_token = "${var.splunk_token}"
    splunk_url = "${var.splunk_url}"
    build_number = "${var.version}"
  }
}

resource "aws_ecs_task_definition" "task" {
  family = "${var.name}"
  container_definitions = "${data.template_file.task.rendered}"
  task_role_arn = "${aws_iam_role.main.arn}"
}

resource "aws_iam_role_policy_attachment" "pull" {
  policy_arn = "${module.ecr_repo.readonly_policy_arn}"
  role = "${aws_iam_role.main.name}"
}

data "aws_caller_identity" "current" {}

data "template_file" "ci_terraform" {
  template = "${file("${path.module}/policies/ci_terraform.json.tpl")}"

  vars {
    aws_region = "${var.aws_region}"
    service_name = "${var.name}"
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_policy" "ci_terraform" {
  name = "${var.name}-ci-policy"
  description = "Access to terraform state files from CI"
  policy = "${data.template_file.ci_terraform.rendered}"
}
