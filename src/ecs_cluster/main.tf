data "aws_ami" "ecs_ami" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-*-amazon-ecs-optimized",
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm",
    ]
  }

  owners = [
    "amazon",
  ]
}

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

// this is cloud-init format user data content
// it creates upstart task "mount_ebs"
// which triggers mount_ebs.sh script before ecs agent is started

// mount_ebs.sh will look for unmounted ebs volumes is same availability
// zone as instance it self. Lookup is done via tags, called "ClusterName"
// assuming that single ECS cluster will have only single external volume

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    cluster_name     = "${var.cluster_name}"
    extra_volumes    = "${var.extra_volumes}"
    efs_storate_name = "${var.efs_storage_name}"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}"
}

resource "aws_iam_role" "ecs_host_role" {
  name               = "ecs_host-${var.cluster_name}"
  assume_role_policy = "${file("${path.module}/policies/ecs_host_role.json")}"
}

resource "aws_iam_instance_profile" "ecs_host_profile" {
  name = "ecs-${format("%s", var.cluster_name)}-host"
  path = "/"

  role = ["${aws_iam_role.ecs_host_role.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecs_host_policy" {
  name = "ecs-${format("%s", var.cluster_name)}-host-policy"
  role = "${aws_iam_role.ecs_host_role.id}"

  policy = "${file("${path.module}/policies/ecs_agent_policy.json")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ecs_host" {
  name        = "${var.cluster_name}_internal_all"
  description = "Allow all traffic from VPC CIDR."

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${data.aws_vpc.vpc.cidr_block}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = "${merge(var.tags, map("Name", format("%s-security-group", var.cluster_name)))}"
}

// launch configuration
resource "aws_launch_configuration" "ecs_host" {
  name_prefix                 = "ecs-${var.cluster_name}-lc"
  image_id                    = "${var.ami != "" ? var.ami : data.aws_ami.ecs_ami.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_host_profile.id}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  user_data = "${data.template_file.user_data.rendered}"

  security_groups = [
    "${compact(split(",", format("%s,%s", aws_security_group.ecs_host.id, join(",", var.security_groups))))}",
  ]

  root_block_device {
    volume_type           = "${var.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = "${var.delete_root_volume_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// autoscaling group
resource "aws_autoscaling_group" "ecs" {
  name = "ecs-${var.cluster_name}"

  vpc_zone_identifier = [
    "${var.subnets}",
  ]

  launch_configuration      = "${aws_launch_configuration.ecs_host.name}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  desired_capacity          = "${var.desired_size}"
  force_delete              = "${var.force_delete}"

  lifecycle {
    ignore_changes = [
      "desired_capacity",
    ]
  }

  tag {
    key                 = "Name"
    value               = "ECS Instance - ${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "ClusterName"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}

// scale group up
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.cluster_name}-ScaleUp"
  autoscaling_group_name = "${aws_autoscaling_group.ecs.name}"
  adjustment_type        = "${var.adjustment_type_up}"
  scaling_adjustment     = "${var.scaling_adjustment_up}"
  cooldown               = "${var.cooldown_up}"
}

// scale group down
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.cluster_name}-ScaleDown"
  autoscaling_group_name = "${aws_autoscaling_group.ecs.name}"
  adjustment_type        = "${var.adjustment_type_down}"
  scaling_adjustment     = "${var.scaling_adjustment_down}"
  cooldown               = "${var.cooldown_down}"
}
