data "aws_ami" "ecs" {
  owners = ["amazon"]

  filter {
    name   = "image-id"
    values = ["ami-07fde2ae86109a2af"]
  }
}

locals {
  user_data = <<EOH
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
EOH
}

resource "aws_instance" "vulnsite" {
  ami                         = data.aws_ami.ecs.id
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  vpc_security_group_ids      = [aws_security_group.ecs_sg.id]
  user_data                   = local.user_data
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id

  tags = {
    "Name"    = "cg-${var.scenario-name}-${var.cgid}-vulnsite"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "32f5c077-34ca-44f4-8b10-4f526e048311"
  }
}

resource "aws_instance" "vault" {
  ami                         = data.aws_ami.ecs.id
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  vpc_security_group_ids      = [aws_security_group.ecs_sg.id]
  user_data                   = local.user_data
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id

  tags = {
    "Name"    = "cg-${var.scenario-name}-${var.cgid}-vault"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "b02d6bcc-cd19-47ca-a366-211090ce9117"
  }
}