//
// ECS Worker Instance Role
//
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "cg-${var.scenario-name}-${var.cgid}-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "f6478c49-1815-477d-98c2-cd9f09005790"
    Owner     = "RGA"
  }
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "cg-${var.scenario-name}-${var.cgid}-ecs-agent"
  role = aws_iam_role.ecs_agent.name
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "eef03930-e1a5-4c0c-bb6d-c2af2959521d"
    Owner     = "RGA"
  }
}



//
//  ECS Container role
//

data "aws_iam_policy_document" "ecs_tasks_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}



resource "aws_iam_role" "privd" {
  name                = "cg-${var.scenario-name}-${var.cgid}-privd"
  assume_role_policy  = data.aws_iam_policy_document.ecs_tasks_role.json
  managed_policy_arns = [aws_iam_policy.privd.arn]
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "6a12022e-d729-4ed9-8eeb-98e059ab1a26"
    Owner     = "RGA"
  }
}

// Give the role read access to ecs and IAM permissions.
resource "aws_iam_policy" "privd" {
  name = "cg-${var.scenario-name}-${var.cgid}-privd"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:ListServices",
          "ecs:ListTasks",
          "ecs:DescribeServices",
          "ecs:ListContainerInstances",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeTasks",
          "ecs:ListTaskDefinitions",
          "ecs:DescribeClusters",
          "ecs:ListClusters",
          "iam:GetPolicyVersion",
          "iam:GetPolicy",
          "iam:ListAttachedRolePolicies",
          "iam:GetRolePolicy"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "105424a2-286d-4318-a7a5-e0328589de81"
    Owner     = "RGA"
  }
}