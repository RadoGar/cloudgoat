resource "aws_iam_user" "developer" {
  name = local.repo_readwrite_username
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "feeadce2-4768-47ec-962f-6ccb1d3da12c"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_iam_user_policy" "developer" {
  name = "developer-policy"
  user = aws_iam_user.developer.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "${aws_codecommit_repository.code.arn}",
      "Action": [
          "codecommit:GitPush",
          "codecommit:GitPull",
          "codecommit:PutFile"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
          "codecommit:Get*",
          "codecommit:List*",
          "codebuild:List*",
          "codebuild:BatchGetProjects",
          "codebuild:BatchGetBuilds",
          "codepipeline:List*",
          "codepipeline:Get*",
          "codedeploy:List*",
          "logs:Get*",
          "logs:Describe*"
      ]
    },
    {
      "Effect": "Deny",
      "Resource": "${aws_codebuild_project.simulate-user-activity.arn}",
      "Action": [
          "*"
      ]
    },
    {
      "Effect": "Allow",
      "Sid": "AllowConsoleAccess",
      "Resource": "arn:aws:sts::${local.account_id}:federated-user/${aws_iam_user.developer.name}",
      "Action": "sts:GetFederationToken"
    }
  ]
}
POLICY
}

resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}
