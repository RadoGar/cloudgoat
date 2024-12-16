resource "aws_iam_user" "cg-calrissian" {
  name = "calrissian"
  tags = {
    Name      = "cg-calrissian-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "53b61566-5d80-466b-adfb-df897ad4d086"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_iam_access_key" "cg-calrissian" {
  user = "${aws_iam_user.cg-calrissian.name}"
}
resource "aws_iam_user" "cg-solo" {
  name = "solo"
  tags = {
    Name      = "cg-solo-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "d58a535a-4aab-496f-b8f0-200d4a835d76"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_iam_access_key" "cg-solo" {
  user = "${aws_iam_user.cg-solo.name}"
}
#IAM User Policies
resource "aws_iam_policy" "cg-calrissian-policy" {
  name        = "cg-calrissian-policy-${var.cgid}"
  description = "cg-calrissian-policy-${var.cgid}"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "calrissian",
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBSnapshot",
                "rds:DescribeDBInstances",
                "rds:ModifyDBInstance",
                "rds:RestoreDBInstanceFromDBSnapshot",
                "rds:DescribeDBSubnetGroups",
                "rds:CreateDBSecurityGroup",
                "rds:DeleteDBSecurityGroup",
                "rds:DescribeDBSecurityGroups",
                "rds:AuthorizeDBSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:AuthorizeSecurityGroupIngress"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "ce83da3e-41b7-4281-b5ef-16cfa63145d9"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_iam_policy" "cg-solo-policy" {
  name        = "cg-solo-policy-${var.cgid}"
  description = "cg-solo-policy-${var.cgid}"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "solo",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "ssm:DescribeParameters",
                "ssm:GetParameter",
                "codebuild:ListProjects",
                "codebuild:BatchGetProjects",
                "codebuild:ListBuilds",
                "ec2:DescribeInstances",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "56d981c1-8062-4122-989b-308f0bf70836"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
#User Policy Attachments
resource "aws_iam_user_policy_attachment" "cg-calrissian-attachment" {
  user       = "${aws_iam_user.cg-calrissian.name}"
  policy_arn = "${aws_iam_policy.cg-calrissian-policy.arn}"
}
resource "aws_iam_user_policy_attachment" "cg-solo-attachment" {
  user       = "${aws_iam_user.cg-solo.name}"
  policy_arn = "${aws_iam_policy.cg-solo-policy.arn}"
}