

resource "aws_instance" "easy_path" {
  ami                         = "ami-033b95fb8079dc481"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile_easy_path.name
  // Do I even need the below key since I'm using ssm?
  // key_name = "delete-this-key-now" 
  vpc_security_group_ids = [aws_security_group.main2.id]
  user_data              = <<EOF
  #!/bin/bash
  cd /tmp
  sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  sudo systemctl enable amazon-ssm-agent
  sudo systemctl start amazon-ssm-agent
  sudo yum remove awscli.noarch -y
  EOF
  tags = {
    Name      = "easy_path-cg-detection-evasion",
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "6a8e5f25-abc6-4eee-97d6-85c4f2a64b48"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_instance" "hard_path" {
  ami           = "ami-033b95fb8079dc481"
  instance_type = "t2.micro"
  // private_ip = "${var.target_IP}"
  // associate_public_ip_address = true
  subnet_id            = aws_subnet.main.id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile_hard_path.name
  // Do I even need the below key since I'm using ssm?
  // key_name = "delete-this-key-now" 
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = <<EOF
  #!/bin/bash
  cd /tmp
  sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  sudo systemctl enable amazon-ssm-agent
  sudo systemctl start amazon-ssm-agent
  EOF
  tags = {
    Name      = "hard_path-cg-detection-evasion",
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "57aa2901-471e-443c-a550-5d528c3240cc"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_security_group" "main" {
  name        = var.cgid
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "4b47984d-95e7-4bec-9ae1-de84b5dbd7ca"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_security_group" "main2" {
  name        = "${var.cgid}2"
  description = "Allow HTTP traffic"

  ingress {
    description = "HTTP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    tag-key   = var.cgid
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "a1b8346f-bf19-492e-9c6f-3dad4f0761aa"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
