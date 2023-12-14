data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_network_interface" "dev" {
  subnet_id   = module.vpc.private_subnets[0]
  private_ips = ["10.0.1.10"]
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "948784c7-612e-4aba-8e52-29d75be3f43f"
  }
}
resource "aws_iam_role" "dev-instance" {
  name = "dev-instance-role"
  path = "/"

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
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "92f34cf6-d997-4acd-b25c-ec34e33d1eea"
  }
}
resource "aws_iam_role_policy_attachment" "dev-instance-policy" {
  role       = aws_iam_role.dev-instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "dev" {
  name = "dev-instance-profile"
  role = aws_iam_role.dev-instance.name
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "feabf884-c00a-402a-8e4f-c24d5d2aabf6"
  }
}
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}
resource "aws_instance" "dev" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.dev.name
  user_data            = templatefile("${path.module}/../assets/dev-machine/provision.sh", { private_ssh_key = tls_private_key.ssh_key.private_key_pem })
  subnet_id            = module.vpc.private_subnets[0]

  tags = {
    Name        = "dev-instance",
    Environment = "dev"
    git_org     = "RadoGar"
    git_repo    = "cloudgoat"
    yor_trace   = "0b58b713-682a-4619-8c5c-fbb36829cd74"
  }
  metadata_options {
    http_tokens = "required"
  }
}

# IAM user
resource "aws_iam_user" "readonly_user" {
  name = local.repo_readonly_username
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "29158ad3-3187-4dfb-8804-18c024ec0a1a"
  }
}
resource "aws_iam_user_ssh_key" "readonly_user" {
  username   = aws_iam_user.readonly_user.name
  encoding   = "SSH"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
resource "aws_iam_user_policy" "readonly_user" {
  name = "readonly_user-policy"
  user = aws_iam_user.readonly_user.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "${aws_codecommit_repository.code.arn}",
      "Action": [
          "codecommit:GitPull"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
          "codecommit:Get*",
          "codecommit:List*"
      ]
    }
  ]
}
POLICY

}
