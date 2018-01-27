[
  {
    "name": "mongo",
    "image": "mongo",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 27017,
        "hostPort": 27017
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "data",
        "containerPath": "/data"
      }
    ]
  }
]
