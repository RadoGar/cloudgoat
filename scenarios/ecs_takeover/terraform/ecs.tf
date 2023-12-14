resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.scenario-name}-${var.cgid}-cluster"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "21f119b7-1ae1-4893-9566-c5f6d11d4047"
    Owner     = "RGA"
  }
}

resource "aws_ecs_task_definition" "vault" {
  family = "cg-${var.scenario-name}-${var.cgid}-vault"

  # Wait for the website to be deployed to the cluster.
  # This should make sure the instances are available.
  container_definitions = jsonencode([
    {
      name      = "vault"
      image     = "busybox:latest"
      essential = true
      cpu       = 50
      memory    = 50
      command   = ["/bin/sh -c \"echo '{{FLAG_1234677}}' >  /FLAG.TXT; sleep 365d\""]
      entryPoint = [
        "sh",
        "-c"
      ]
    }
  ])
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "81f8d2c0-43ab-401f-86dd-ca566d084160"
    Owner     = "RGA"
  }
}

// Hosts the role we want to use to force rescheduling
resource "aws_ecs_task_definition" "privd" {
  family        = "cg-${var.scenario-name}-${var.cgid}-privd"
  task_role_arn = aws_iam_role.privd.arn
  container_definitions = jsonencode([
    {
      name      = "privd"
      image     = "busybox:latest"
      cpu       = 50
      memory    = 50
      essential = true
      command   = ["sleep", "365d"]
    }
  ])
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "c36d7274-971f-4608-9e16-c02edc404411"
    Owner     = "RGA"
  }
}

// Hosts website to container escape
resource "aws_ecs_task_definition" "vulnsite" {
  family       = "cg-${var.scenario-name}-${var.cgid}-vulnsite"
  network_mode = "host"
  container_definitions = jsonencode([
    {
      name         = "vulnsite"
      image        = "cloudgoat/ecs-takeover-vulnsite:latest"
      essential    = true
      privileged   = true
      network_mode = "awsvpc"
      cpu          = 256
      memory       = 256
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      mountPoints = [
        {
          readOnly      = false,
          containerPath = "/var/run/docker.sock"
          sourceVolume  = "docker-socket"
        }
      ]
    }
  ])

  volume {
    name      = "docker-socket"
    host_path = "/var/run/docker.sock"
  }
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "2c9ce670-4547-444c-8482-42691b5f9b01"
    Owner     = "RGA"
  }
}


resource "aws_ecs_service" "vulnsite" {
  name            = "vulnsite"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.vulnsite.arn
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "ec2InstanceId == ${aws_instance.vulnsite.id}"
  }
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "dc4fcf36-34e8-4293-bb4d-e9ee1bbd1103"
    Owner     = "RGA"
  }
}

resource "aws_ecs_service" "privd" {
  name                 = "privd"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = aws_ecs_task_definition.privd.arn
  force_new_deployment = true
  scheduling_strategy  = "DAEMON"
  desired_count        = 2
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "9409fec9-18fb-48fc-b7ee-56d75d209754"
    Owner     = "RGA"
  }
}


resource "aws_ecs_service" "vault" {
  name                 = "vault"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = aws_ecs_task_definition.vault.arn
  force_new_deployment = true
  desired_count        = 1


  depends_on = [
    aws_ecs_service.vulnsite,
  ]

  ordered_placement_strategy {
    type = "random"
  }

  // Setting this here ensures vault start's on the right instance, this setting is removed in the provisioner below.
  placement_constraints {
    type       = "memberOf"
    expression = "ec2InstanceId == ${aws_instance.vault.id}"
  }

  provisioner "local-exec" {
    command = "/usr/bin/env python3 remove_placement_constraints.py"
    environment = {
      CLUSTER            = self.cluster
      SERVICE_NAME       = self.name
      AWS_DEFAULT_REGION = var.region
      AWS_PROFILE        = var.profile
    }
  }
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "54b01cd9-e904-415a-8194-282f86e29786"
    Owner     = "RGA"
  }
}
