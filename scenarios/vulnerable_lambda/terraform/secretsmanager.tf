resource "aws_secretsmanager_secret" "final_flag" {
  name = "${var.cgid}-final_flag"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "ecfe3240-c199-42e2-a961-2841d8e92bdf"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_secretsmanager_secret_version" "final_flag_value" {
  secret_id     = aws_secretsmanager_secret.final_flag.id
  secret_string = "cg-secret-846237-284529"
}