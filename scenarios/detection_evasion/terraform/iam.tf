#IAM Users and Keys
resource "aws_iam_user" "r_waterhouse" {
  name = "r_waterhouse"
  path = "/"
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "068d95a9-f764-4fad-974b-888c6fa90e19"
  }
}

resource "aws_iam_access_key" "r_waterhouse" {
  user = aws_iam_user.r_waterhouse.name
}

resource "aws_iam_user" "canarytoken_user" {
  name = "canarytokens.com@@kz9r8ouqnhve4zs1yi4bzspzz"
  path = "/"
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "4cc24194-7065-4fca-84cf-2f33da672e54"
  }
}

resource "aws_iam_access_key" "canarytoken_user" {
  user = aws_iam_user.canarytoken_user.name
}

resource "aws_iam_user" "spacecrab_user" {
  name = "l_salander"
  path = "/SpaceCrab/"
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "90954d22-587d-4679-8929-e9b69a98fdf6"
  }
}

resource "aws_iam_access_key" "spacecrab_user" {
  user = aws_iam_user.spacecrab_user.name
}

resource "aws_iam_user" "spacesiren_user" {
  name = "cd1fceca-e751-4c1b-83e4-78d309063830"
  path = "/"
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "1fc5cd84-ffae-4aec-a584-e2a8381a0de2"
  }
}

resource "aws_iam_access_key" "spacesiren_user" {
  user = aws_iam_user.spacesiren_user.name
}

#IAM Groups and Members
resource "aws_iam_group" "developers" {
  name = "cg-developers"
  path = "/developers/"
}

resource "aws_iam_group_membership" "dev_team" {
  name = "developer_group_membership"
  users = [
    aws_iam_user.r_waterhouse.name,
  ]
  group = aws_iam_group.developers.name
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


resource "aws_iam_group_policy" "developer_policy" {
  name  = "developer_policy"
  group = aws_iam_group.developers.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:ResumeSession",
          "ssm:TerminateSession",
          "ssm:StartSession"
        ]
        Resource = [
          "arn:aws:ssm:*:*:patchbaseline/*",
          "arn:aws:ssm:*:*:managed-instance/*",
          "arn:aws:ec2:*:*:instance/*",
          "arn:aws:ssm:*:*:session/*",
          "arn:aws:ssm:*:*:document/*"
        ]
      },
    ]
  })
}


# instance profile for the easy path
resource "aws_iam_instance_profile" "ec2_instance_profile_easy_path" {
  name = "${var.cgid}_easy"
  role = aws_iam_role.ec2_instance_profile_role_easy_path.name
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "15a0e6ce-4739-46b3-a916-d27e46d227d0"
  }
}

resource "aws_iam_role" "ec2_instance_profile_role_easy_path" {
  name = "${var.cgid}_easy"
  path = "/"
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "29bd593e-dc62-4d12-afb4-d27da5223c19"
  }
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy_core_easy_path" {
  role       = aws_iam_role.ec2_instance_profile_role_easy_path.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy_easy_path" {
  role       = aws_iam_role.ec2_instance_profile_role_easy_path.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy" "instance_profile_easy_path" {
  name = "cg_instance_profile_policy_easy_path"
  role = aws_iam_role.ec2_instance_profile_role_easy_path.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
        ],
        "Resource" : aws_secretsmanager_secret.easy_secret.arn
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:ListSecrets",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        "Resource" : "*"
      }
    ]
  })
}

// instance profile for the hard path
resource "aws_iam_instance_profile" "ec2_instance_profile_hard_path" {
  name = "${var.cgid}_hard"
  role = aws_iam_role.ec2_instance_profile_role_hard_path.name
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "bb9af282-5674-4543-938c-36af74561327"
  }
}

resource "aws_iam_role" "ec2_instance_profile_role_hard_path" {
  name = "${var.cgid}_hard"
  path = "/"
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "e4e268bc-91ff-4a52-bf86-a0c90a7b54dc"
  }
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy_core_hard_path" {
  role       = aws_iam_role.ec2_instance_profile_role_hard_path.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy_hard_path" {
  role       = aws_iam_role.ec2_instance_profile_role_hard_path.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


resource "aws_iam_role_policy" "instance_profile_hard_path" {
  name = "cg_instance_profile_policy_hard_path"
  role = aws_iam_role.ec2_instance_profile_role_hard_path.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
        ],
        "Resource" : aws_secretsmanager_secret.hard_secret.arn
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:ListSecrets",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        "Resource" : "*"
      }
    ]
  })
}