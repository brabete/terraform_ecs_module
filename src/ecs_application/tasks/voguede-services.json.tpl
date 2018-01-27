[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "essential": true,
    "environment": [
      { "name": "NODE_ENV", "value": "${node_env}" },
      { "name": "NODE_MONGODB", "value": "${node_mongodb}" },
      { "name": "NODE_SOLR_HOSTNAME", "value": "${node_solr_hostname}" }
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
    },
    "mountPoints": [
    ],
    "dockerLabels": {
    }
  }
]
