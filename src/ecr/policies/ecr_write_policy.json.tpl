{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": [
        "ecr:DeleteRepository",
        "ecr:DeleteRepositoryPolicy",
        "ecr:CreateRepository"
      ],
      "Resource": [
        "${repository_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": [
        "${repository_arn}"
      ]
    }
  ]
}
