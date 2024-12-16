resource "aws_vpc" "cg-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name      = "CloudGoat ${var.cgid} VPC"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "97436344-6979-47f5-b9f9-d95032bbeac1"
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
    yor_trace = "14208958-81ea-4585-87d8-ca8ac5e6d506"
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
    yor_trace = "82a3779f-34e9-43ba-866c-75730121fa65"
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
    yor_trace = "ec1b5dd3-c2b5-4e8b-9697-a66547254654"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
#Private Subnets
resource "aws_subnet" "cg-private-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.10.30.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Private Subnet #1"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "21083094-9b4b-474b-84c4-915aafbb0d21"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_subnet" "cg-private-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.10.40.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Private Subnet #2"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "3a679be0-4a0d-41a9-92f8-5599fffce5d3"
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
    yor_trace = "ff940979-f324-4974-b572-fe8d172c2e61"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
#Private Subnet Routing Table
resource "aws_route_table" "cg-private-subnet-route-table" {
  vpc_id = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Route Table for Private Subnet"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "d3d04cec-3b55-4fcb-a641-675a84646a34"
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
#Private Subnets Routing Associations
resource "aws_route_table_association" "cg-priate-subnet-1-route-association" {
  subnet_id      = "${aws_subnet.cg-private-subnet-1.id}"
  route_table_id = "${aws_route_table.cg-private-subnet-route-table.id}"
}
resource "aws_route_table_association" "cg-priate-subnet-2-route-association" {
  subnet_id      = "${aws_subnet.cg-private-subnet-2.id}"
  route_table_id = "${aws_route_table.cg-private-subnet-route-table.id}"
}