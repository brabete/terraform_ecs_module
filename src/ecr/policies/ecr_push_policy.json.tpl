{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": [
        "${repository_arn}"
      ]
    },
    {
      "Effect" :"Allow",
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Resource":[
        "*"
      ]
    }
  ]
}
