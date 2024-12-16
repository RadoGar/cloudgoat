resource "aws_vpc" "cg-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name      = "CloudGoat ${var.cgid} VPC"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "c9658168-334c-47d0-ac6d-7771d4319c36"
    Owner     = "RGA"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "cg-internet-gateway" {
  vpc_id = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Internet Gateway"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "3e8a9a82-dbfa-4038-b9c8-9381850846d2"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
#Public Subnets
resource "aws_subnet" "cg-public-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.10.10.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Public Subnet #1"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "9d6076fb-ac13-4dce-8ae7-24ebf37aefed"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_subnet" "cg-public-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.10.20.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Public Subnet #2"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "06fe42c4-4956-4829-8e63-22079af144ca"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
#Public Subnet Routing Table
resource "aws_route_table" "cg-public-subnet-route-table" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.cg-internet-gateway.id}"
  }
  vpc_id = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Route Table for Public Subnet"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "6ab451d4-a13b-4d7f-8653-e889bd89e980"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
#Public Subnets Routing Associations
resource "aws_route_table_association" "cg-public-subnet-1-route-association" {
  subnet_id      = "${aws_subnet.cg-public-subnet-1.id}"
  route_table_id = "${aws_route_table.cg-public-subnet-route-table.id}"
}
resource "aws_route_table_association" "cg-public-subnet-2-route-association" {
  subnet_id      = "${aws_subnet.cg-public-subnet-2.id}"
  route_table_id = "${aws_route_table.cg-public-subnet-route-table.id}"
}