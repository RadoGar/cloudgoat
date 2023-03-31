#VPC
resource "aws_vpc" "cg-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name      = "CloudGoat ${var.cgid} VPC"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "9136e0d3-2cac-49aa-8e64-1f30cf43d986"
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
    yor_trace = "b4aeb754-912f-4bfc-b74e-764928beee22"
  }
}
#Public Subnet
resource "aws_subnet" "cg-public-subnet" {
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  cidr_block              = "10.0.10.0/24"
  vpc_id                  = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat ${var.cgid} Public Subnet"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "d9638a2b-a349-436e-9d1c-8f594099d766"
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
    yor_trace = "69bd3029-061e-4618-a225-5746bd778bb8"
  }
}
#Public Subnet Routing Association
resource "aws_route_table_association" "cg-public-subnet-route-association" {
  subnet_id      = "${aws_subnet.cg-public-subnet.id}"
  route_table_id = "${aws_route_table.cg-public-subnet-route-table.id}"
}