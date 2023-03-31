#IAM Role
resource "aws_iam_role" "cg-banking-WAF-Role" {
  name               = "cg-banking-WAF-Role-${var.cgid}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name      = "cg-banking-WAF-Role-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "ea6f9a99-51ed-4311-9f8d-33a0ccb1fdc1"
  }
}

#IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "cg-banking-WAF-Role-policy-attachment-s3" {
  role       = "${aws_iam_role.cg-banking-WAF-Role.name}"
  policy_arn = "${data.aws_iam_policy.s3-full-access.arn}"
}

#IAM Instance Profile
resource "aws_iam_instance_profile" "cg-ec2-instance-profile" {
  name = "cg-ec2-instance-profile-${var.cgid}"
  role = "${aws_iam_role.cg-banking-WAF-Role.name}"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "b268b075-646e-4392-ac54-802b90533a77"
  }
}

#Security Groups
resource "aws_security_group" "cg-ec2-ssh-security-group" {
  name        = "cg-ec2-ssh-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for EC2 Instance over SSH"
  vpc_id      = "${aws_vpc.cg-vpc.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cg_whitelist
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name      = "cg-ec2-ssh-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "208f31b5-ec78-4270-a920-d21936ff522b"
  }
}
resource "aws_security_group" "cg-ec2-http-security-group" {
  name        = "cg-ec2-http-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for EC2 Instance over HTTP"
  vpc_id      = "${aws_vpc.cg-vpc.id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cg_whitelist
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name      = "cg-ec2-http-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "4b8c43e3-ff73-4942-822c-11ca2df9f5a2"
  }
}
#AWS Key Pair
resource "aws_key_pair" "cg-ec2-key-pair" {
  key_name   = "cg-ec2-key-pair-${var.cgid}"
  public_key = "${file(var.ssh-public-key-for-ec2)}"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "920fc902-add3-48c8-ad15-5db3f1fca9b7"
  }
}
#EC2 Instance
resource "aws_instance" "ec2-vulnerable-proxy-server" {
  ami                         = "ami-0a313d6098716f372"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.cg-ec2-instance-profile.name}"
  subnet_id                   = "${aws_subnet.cg-public-subnet-1.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.cg-ec2-ssh-security-group.id}",
    "${aws_security_group.cg-ec2-http-security-group.id}"
  ]
  key_name = "${aws_key_pair.cg-ec2-key-pair.key_name}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  provisioner "file" {
    source      = "../assets/proxy.com"
    destination = "/home/ubuntu/proxy.com"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.ssh-private-key-for-ec2)}"
      host        = self.public_ip
    }
  }
  user_data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y nginx
        ufw allow 'Nginx HTTP'
        cp /home/ubuntu/proxy.com /etc/nginx/sites-enabled/proxy.com
        rm /etc/nginx/sites-enabled/default
        systemctl restart nginx
        EOF
  volume_tags = {
    Name     = "CloudGoat ${var.cgid} EC2 Instance Root Device"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
  tags = {
    Name      = "ec2-vulnerable-proxy-server-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "6ab4e5ec-a2e3-4650-995d-75bb7ed3d2b6"
  }
}