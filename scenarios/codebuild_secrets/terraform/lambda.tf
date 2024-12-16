data "archive_file" "cg-lambda-function" {
  type        = "zip"
  source_file = "../assets/lambda.py"
  output_path = "../assets/lambda.zip"
}
resource "aws_iam_role" "cg-lambda-role" {
  name               = "cg-lambda-role-${var.cgid}-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name      = "cg-lambda-role-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "930454f5-f302-463a-bc5e-7288e6ebead7"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_lambda_function" "cg-lambda-function" {
  filename         = "../assets/lambda.zip"
  function_name    = "cg-lambda-${var.cgid}"
  role             = "${aws_iam_role.cg-lambda-role.arn}"
  handler          = "lambda.handler"
  source_code_hash = "${data.archive_file.cg-lambda-function.output_base64sha256}"
  runtime          = "python3.9"
  environment {
    variables = {
      DB_NAME     = "${var.rds-database-name}"
      DB_USER     = "${var.rds-username}"
      DB_PASSWORD = "${var.rds-password}"
    }
  }
  tags = {
    Name      = "cg-lambda-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "8646164d-534e-4d5b-9c8c-75d8a0233571"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
