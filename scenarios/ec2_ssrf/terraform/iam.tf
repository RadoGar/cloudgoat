#IAM Users
resource "aws_iam_user" "cg-solus" {
  name = "solus-${var.cgid}"
  tags = {
    Name      = "cg-solus-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "7f14dc1f-f076-4047-b8ac-25ad62ae35b7"
    Owner     = "RGA"
  }
}
resource "aws_iam_access_key" "cg-solus" {
  user = "${aws_iam_user.cg-solus.name}"
}
resource "aws_iam_user" "cg-wrex" {
  name = "wrex-${var.cgid}"
  tags = {
    Name      = "cg-wrex-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "0427d1e1-7c6b-4700-99d8-e499f0dccfde"
    Owner     = "RGA"
  }
}
resource "aws_iam_access_key" "cg-wrex" {
  user = "${aws_iam_user.cg-wrex.name}"
}
resource "aws_iam_user" "cg-shepard" {
  name = "shepard-${var.cgid}"
  tags = {
    Name      = "cg-shepard-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "8c0af8be-dfce-4ac2-822e-3fbb57d50950"
    Owner     = "RGA"
  }
}
resource "aws_iam_access_key" "cg-shepard" {
  user = "${aws_iam_user.cg-shepard.name}"
}
#IAM User Policies
resource "aws_iam_policy" "cg-solus-policy" {
  name        = "cg-solus-policy-${var.cgid}"
  description = "cg-solus-policy-${var.cgid}"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "solus",
            "Effect": "Allow",
            "Action": [
                "lambda:Get*",
                "lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "2a8d18ce-fa09-478d-ae33-c79445efae38"
    Owner     = "RGA"
  }
}
resource "aws_iam_policy" "cg-wrex-policy" {
  name        = "cg-wrex-policy-${var.cgid}"
  description = "cg-wrex-policy-${var.cgid}"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "wrex",
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "845a910c-c7bf-4422-9328-30cf854e219e"
    Owner     = "RGA"
  }
}
resource "aws_iam_policy" "cg-shepard-policy" {
  name        = "cg-shepard-policy-${var.cgid}"
  description = "cg-shepard-policy-${var.cgid}"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "shepard",
            "Effect": "Allow",
            "Action": [
                "lambda:Get*",
                "lambda:Invoke*",
                "lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "6dc2e8f1-0984-4775-86b3-d093fd94a7b6"
    Owner     = "RGA"
  }
}
#User Policy Attachments
resource "aws_iam_user_policy_attachment" "cg-solus-attachment" {
  user       = "${aws_iam_user.cg-solus.name}"
  policy_arn = "${aws_iam_policy.cg-solus-policy.arn}"
}
resource "aws_iam_user_policy_attachment" "cg-wrex-attachment" {
  user       = "${aws_iam_user.cg-wrex.name}"
  policy_arn = "${aws_iam_policy.cg-wrex-policy.arn}"
}
resource "aws_iam_user_policy_attachment" "cg-shepard-attachment" {
  user       = "${aws_iam_user.cg-shepard.name}"
  policy_arn = "${aws_iam_policy.cg-shepard-policy.arn}"
}