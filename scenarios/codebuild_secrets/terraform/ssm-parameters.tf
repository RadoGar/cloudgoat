#AWS SSM Parameters
resource "aws_ssm_parameter" "cg-ec2-public-key" {
  name        = "cg-ec2-public-key-${var.cgid}"
  description = "cg-ec2-public-key-${var.cgid}"
  type        = "String"
  value       = "${file("../cloudgoat.pub")}"
  tags = {
    Name      = "cg-ec2-public-key-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "078f2e09-a367-44f5-a109-b3ee202d8e22"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_ssm_parameter" "cg-ec2-private-key" {
  name        = "cg-ec2-private-key-${var.cgid}"
  description = "cg-ec2-private-key-${var.cgid}"
  type        = "String"
  value       = "${file("../cloudgoat")}"
  tags = {
    Name      = "cg-ec2-private-key-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "fecc2163-60f0-4cc8-a8d5-58d01a42c8fc"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}