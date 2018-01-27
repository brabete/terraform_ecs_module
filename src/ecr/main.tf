resource "aws_ecr_repository" "main" {
  name = "${var.name}"
}

data "template_file" "readonly_policy_template" {
  template = "${file("${path.module}/policies/ecr_readonly_policy.json.tpl")}"

  vars {
    repository_arn = "${aws_ecr_repository.main.arn}"
  }
}

data "template_file" "write_policy_template" {
  template = "${file("${path.module}/policies/ecr_write_policy.json.tpl")}"

  vars {
    repository_arn = "${aws_ecr_repository.main.arn}"
  }
}

data "template_file" "push_policy_template" {
  template = "${file("${path.module}/policies/ecr_push_policy.json.tpl")}"

  vars {
    repository_arn = "${aws_ecr_repository.main.arn}"
  }
}

resource "aws_iam_policy" "readonly_policy" {
  name        = "ecr-${var.name}-readonly"
  policy      = "${data.template_file.readonly_policy_template.rendered}"
  description = "Read only access to ECR ${var.name}"
}

resource "aws_iam_policy" "write_policy" {
  name        = "ecr-${var.name}-write"
  policy      = "${data.template_file.write_policy_template.rendered}"
  description = "Read and write access to ECR ${var.name}"
}

resource "aws_iam_policy" "push_policy" {
  name        = "ecr-${var.name}-push"
  policy      = "${data.template_file.push_policy_template.rendered}"
  description = "Push Docker image to ECR ${var.name}"
}
