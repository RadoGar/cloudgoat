# Scheduling
resource "aws_iam_role" "simulate-user-activity-scheduling" {
  name = "simulate-user-activity-scheduling-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "45f6bf28-ee4b-475b-8d10-253f5470183e"
  }
}

resource "aws_iam_role_policy" "simulate-user-activity-scheduling" {
  role = aws_iam_role.simulate-user-activity-scheduling.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:StartBuild"
      ],
      "Resource": "${aws_codebuild_project.simulate-user-activity.arn}"
    }
  ]
}
POLICY
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "simulated-user-activity"
  description         = "Simulate user activity on the API"
  schedule_expression = "rate(1 minute)"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "d85765ff-4627-4795-a1cd-4679a06cda62"
  }
}
resource "aws_cloudwatch_event_target" "codebuild" {
  target_id = "trigger-codebuild"
  rule      = aws_cloudwatch_event_rule.schedule.id
  arn       = aws_codebuild_project.simulate-user-activity.arn
  role_arn  = aws_iam_role.simulate-user-activity-scheduling.arn
}


# Codebuild
resource "aws_codebuild_project" "simulate-user-activity" {
  name         = "OUTOFSCOPE_simulate-user-activity"
  service_role = aws_iam_role.simulate-user-activity.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name = "SECRET_FLAG"
      # Note: This is a base64 version of the secret flag
      # It shouldn't be accessible in the live environment because the step3 user has an
      # explicit deny on this CloudBuild project
      value = "RkxBR3tTdXBwbHlDaDQhblMzY3VyaXR5TTR0dDNyNSJ9"
    }

    environment_variable {
      name  = "API_URL"
      value = aws_apigatewayv2_stage.prod.invoke_url
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/../assets/simulated-user-activity/buildspec.yml")
  }
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "cf24aead-ead8-4dc4-921f-b2cc198fa796"
  }
}


resource "aws_iam_role" "simulate-user-activity" {
  name = "simulate-user-activity-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "dabcae5a-9b41-4a23-adfb-064d14d65375"
  }
}
resource "aws_iam_role_policy" "simulate-user-activity" {
  role = aws_iam_role.simulate-user-activity.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}