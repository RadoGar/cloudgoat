#IAM Users
resource "aws_iam_user" "cg-raynor" {
  name = "raynor-${var.cgid}"
  tags = {
    Name      = "cg-raynor-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "8f7e9c7e-4b1e-45ab-8a51-8a81ac141688"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_iam_access_key" "cg-raynor" {
  user = "${aws_iam_user.cg-raynor.name}"
}

#IAM User Policies
resource "aws_iam_policy" "cg-raynor-policy" {
  name        = "cg-raynor-policy-${var.cgid}"
  description = "cg-raynor-policy"
  policy      = "${file("../assets/policies/v1.json")}"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "12e798ce-982f-4c35-81eb-5bd5d5b52a0b"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

#IAM Policy Attachments
resource "aws_iam_user_policy_attachment" "cg-raynor-attachment" {
  user       = "${aws_iam_user.cg-raynor.name}"
  policy_arn = "${aws_iam_policy.cg-raynor-policy.arn}"
}
