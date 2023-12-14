#VPC
resource "aws_vpc" "cg-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name      = "CloudGoat VPC"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "714c105c-2c39-4267-a36e-b39548be058c"
    Owner     = "RGA"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "cg-internet-gateway" {
  vpc_id = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat Internet Gateway"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "c700952b-a3cb-4cd2-b37b-332caaddabb3"
    Owner     = "RGA"
  }
}
#Public Subnets
resource "aws_subnet" "cg-public-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.10.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat Public Subnet #1"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "4d87276a-4266-4505-ab59-2fa43088b17f"
    Owner     = "RGA"
  }
}
resource "aws_subnet" "cg-public-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.0.20.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat Public Subnet #2"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "99404c59-9751-46a8-be91-185beca05cf9"
    Owner     = "RGA"
  }
}
#Private Subnets
resource "aws_subnet" "cg-private-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.30.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat Private Subnet #1"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "aaf5e6e7-ef84-4acf-aa56-401185b33895"
    Owner     = "RGA"
  }
}
resource "aws_subnet" "cg-private-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.0.40.0/24"
  vpc_id            = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat Private Subnet #2"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "7ca8c618-8620-439f-aa81-136d1dfb188a"
    Owner     = "RGA"
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
    Name      = "CloudGoat Route Table for Public Subnet"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "ba1faa5a-0d35-42f3-96e7-40aa01eed237"
    Owner     = "RGA"
  }
}
#Private Subnet Routing Table
resource "aws_route_table" "cg-private-subnet-route-table" {
  vpc_id = "${aws_vpc.cg-vpc.id}"
  tags = {
    Name      = "CloudGoat Route Table for Private Subnet"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "83b9b190-9820-4a77-9bd3-4c2da17f05e7"
    Owner     = "RGA"
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