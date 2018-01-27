[
  {
    "name": "${name}",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "essential": true,
    "environment": [
        { "name": "AMAZON_ECS", "value": "true" },
        { "name": "NODE_ENV", "value": "${node_env}"},
        { "name": "BUILD_NUMBER", "value": "${build_number}"}
    ],
    "portMappings": [
      {
        "containerPort": ${application_port},
        "protocol": "tcp"
      }
    ],
    "mountPoints": [
    ],
    "dockerLabels": {
    },
    "logConfiguration": {
        "logDriver": "splunk",
        "options": {
            "splunk-url": "${splunk_url}",
            "splunk-token": "${splunk_token}",
            "splunk-insecureskipverify": "true",
            "splunk-verify-connection": "false",
            "splunk-format": "json",
            "env": "NODE_ENV",
            "labels": "${node_env}",
            "tag": "{{.ImageName}}/{{.Name}}/{{.ID}}"
        }
    }
  }
]
