resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name"    = "cg-${var.scenario-name}-${var.cgid}-main"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "fad82cd4-8768-4b44-be83-2351c66c6de4"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"    = "cg-${var.scenario-name}-${var.cgid}-main"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "b8176822-3a6e-4ed8-aa3f-b000c938873a"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"

  tags = {
    "Name"    = "cg-${var.scenario-name}-${var.cgid}-public"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "1aee1d50-051d-4569-b528-e0174fc528b8"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    "Name"    = "cg-${var.scenario-name}-${var.cgid}-public"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "22f9cb40-ba8a-45ff-a1b7-c20d0a36513a"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs_sg" {
  vpc_id                 = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cg_whitelist
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cg_whitelist
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"    = "cg-${var.scenario-name}-${var.cgid}-ecs-sg"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "673328c5-4674-426c-84b3-784ffdeaebd1"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}