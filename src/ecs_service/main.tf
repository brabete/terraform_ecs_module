// target group
resource "aws_alb_target_group" "main" {
  // target group name limited to 32 characters and only alpha + num + hypens
  name     = "${var.service_name}-${var.environment}"
  port     = "${var.service_port}"
  protocol = "${var.service_protocol}"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled         = "${var.stickiness_enabled}"
    type            = "${var.stickiness_type}"
    cookie_duration = "${var.stickiness_cookie_duration}"
  }

  health_check {
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    port                = "${var.health_check_port}"
    protocol            = "${var.health_check_protocol}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    matcher             = "${var.health_check_matcher}"
  }

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.service_name, var.environment)))}"

  // based on https://github.com/hashicorp/terraform/issues/12634
  depends_on = [
    "aws_alb.main",
  ]
}

// application load balancer
resource "aws_alb" "main" {
  subnets = [
    "${var.subnets}",
  ]

  internal = "${var.internal}"
  name     = "${var.service_name}-${var.environment}"

  enable_deletion_protection = "${var.alb_deletion_protection}"

  security_groups = [
    "${var.alb_security_groups}",
  ]

  access_logs {
    bucket  = "${var.alb_logs_s3_bucket}"
    prefix  = "${var.alb_logs_s3_prefix}"
    enabled = "${var.alb_logs_s3_enabled}"
  }

  tags = "${merge(var.tags, map("Name", format("%s-alb", var.service_name)))}"
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = "${var.service_port}"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.main.arn}"
  }

  depends_on = [
    "aws_alb_target_group.main",
  ]
}

resource "aws_ecs_service" "app" {
  name                               = "${var.service_name}"
  task_definition                    = "${var.task_arn}"
  cluster                            = "${var.ecs_cluster_name}"
  desired_count                      = "${var.desired_count}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
  iam_role                           = "${var.ecs_agent_role}"

  lifecycle {
    ignore_changes = [
      "desired_count",
    ]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.main.arn}"
    container_port   = "${var.container_port}"
    container_name   = "${var.service_name}"
  }
}

resource "aws_route53_record" "internal_dns_record" {
  zone_id = "${var.private_zone_id}"
  name    = "${var.service_name}.${var.environment}.${var.domain}"
  type    = "CNAME"
  ttl     = 60

  records = [
    "${aws_alb.main.dns_name}",
  ]

  count = "${var.private_zone_id == "" ? 0 : 1}"
}

resource "aws_route53_record" "external_dns_record" {
  zone_id = "${var.public_zone_id}"
  name    = "${var.service_name}.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.main.dns_name}"
    zone_id                = "${aws_alb.main.zone_id}"
    evaluate_target_health = false
  }

  count = "${var.public_zone_id == "" ? 0 : 1}"
}

data "template_file" "update_policy_template" {
  template = "${file("${path.module}/policies/ecs_update_policy.json.tpl")}"
}

resource "aws_iam_policy" "ecs_update_policy" {
  name        = "ecs-${var.service_name}-update"
  policy      = "${data.template_file.update_policy_template.rendered}"
  description = "Update service ${var.service_name}"
}
