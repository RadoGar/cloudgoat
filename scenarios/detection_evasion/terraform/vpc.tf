resource "aws_vpc" "main" {
  cidr_block           = "3.84.104.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "8ed9ce25-c821-474e-9c77-5bda9f6f5d27"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "3.84.104.0/24"

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "e5fe6b0f-0c0d-4e20-9125-a61d4a03b0cf"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

// VPC ENDPOINTS BELOW
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.main.id]
  security_group_ids = [
    aws_security_group.main.id,
  ]

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "11ef7c30-917c-4ce5-b819-bc3e165d6fb9"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.main.id]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.main.id,
  ]

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "5b673763-2042-4670-a73c-56d650d94684"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.main.id]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.main.id,
  ]

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "ae8035cb-2c67-48ef-99d8-e1e6ef874f7e"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

// resource "aws_vpc_endpoint" "ec2" {
//   vpc_id       = aws_vpc.main.id
//   service_name = "com.amazonaws.${var.region}.ec2"
//   vpc_endpoint_type = "Interface"
//   subnet_ids = ["${aws_subnet.main.id}"]
//   private_dns_enabled = true
//   security_group_ids = [
//     aws_security_group.main.id,
//   ]

//   tags = {
//     tag-key = "${var.cgid}"
//   }
// }

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.main.id]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.main.id,
  ]

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "fec5c42c-cb07-483f-b44b-58188a34dd67"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.main.id]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.main.id,
  ]

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "1544dc1b-1eba-4f42-b969-c5a6a4e83a53"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}