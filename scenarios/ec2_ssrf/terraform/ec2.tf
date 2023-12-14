#IAM Role
resource "aws_iam_role" "cg-ec2-role" {
  name               = "cg-ec2-role-${var.cgid}"
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
    Name      = "cg-ec2-role-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "0b279109-2404-4ef0-a961-80509f243e48"
  }
}
#Iam Role Policy
resource "aws_iam_policy" "cg-ec2-role-policy" {
  name        = "cg-ec2-role-policy-${var.cgid}"
  description = "cg-ec2-role-policy-${var.cgid}"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "cloudwatch:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "b53911c7-af7b-4ca1-883b-1cd0eec5c487"
  }
}
#IAM Role Policy Attachment
resource "aws_iam_policy_attachment" "cg-ec2-role-policy-attachment" {
  name = "cg-ec2-role-policy-attachment-${var.cgid}"
  roles = [
    "${aws_iam_role.cg-ec2-role.name}"
  ]
  policy_arn = "${aws_iam_policy.cg-ec2-role-policy.arn}"
}
#IAM Instance Profile
resource "aws_iam_instance_profile" "cg-ec2-instance-profile" {
  name = "cg-ec2-instance-profile-${var.cgid}"
  role = "${aws_iam_role.cg-ec2-role.name}"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "0e9d91ca-923d-4454-a32a-44686da3f20a"
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
    yor_trace = "1b84e8fe-34e2-4856-b8aa-fdfdc5abded5"
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
    yor_trace = "0f26ae2b-e129-4c9d-8df3-f55a4f518c92"
  }
}
#AWS Key Pair
resource "aws_key_pair" "cg-ec2-key-pair" {
  key_name   = "cg-ec2-key-pair-${var.cgid}"
  public_key = "${file(var.ssh-public-key-for-ec2)}"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "6aa9ac8d-9acf-4548-b5eb-12453e56cd63"
  }
}
#EC2 Instance
resource "aws_instance" "cg-ubuntu-ec2" {
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
    source      = "../assets/ssrf_app/app.zip"
    destination = "/home/ubuntu/app.zip"
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
        curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
        DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs unzip
        npm install http express needle command-line-args
        cd /home/ubuntu
        unzip app.zip -d ./app
        cd app
        sudo node ssrf-demo-app.js &
        echo -e "\n* * * * * root node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 10; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 20; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 30; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 40; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 50; node /home/ubuntu/app/ssrf-demo-app.js &\n" >> /etc/crontab
        EOF
  volume_tags = {
    Name     = "CloudGoat ${var.cgid} EC2 Instance Root Device"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
  tags = {
    Name      = "cg-ubuntu-ec2-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "78b4acc5-1ba6-47df-a128-4c6c29793334"
  }
  metadata_options {
    http_tokens = "required"
  }
}
