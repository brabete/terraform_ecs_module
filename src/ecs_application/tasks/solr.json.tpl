[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "essential": true,
    "environment": [
    ],
    "portMappings": [
      {
        "containerPort": ${application_port},
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${ecs_log_group}",
        "awslogs-region": "${aws_log_region}"
      }
    }
  }
]
