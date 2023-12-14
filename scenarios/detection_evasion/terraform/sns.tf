# does the resource below need a a detailed delivery policy for any reason? Might be worth looking into.
resource "aws_sns_topic" "honeytoken_detected" {
  name = "phase1"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "2f52123d-1447-405c-aba7-06ee5ad6ac64"
    Owner     = "RGA"
  }
}

resource "aws_sns_topic_subscription" "honeytoken_subscription" {
  topic_arn = aws_sns_topic.honeytoken_detected.arn
  protocol  = "email"
  endpoint  = var.user_email
}

resource "aws_sns_topic" "instance_profile_abnormally_used" {
  name = "phase2"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "d67c15f7-e462-4af2-8fd6-6df88c75f288"
    Owner     = "RGA"
  }
}

resource "aws_sns_topic_subscription" "instance_profile_subscription" {
  topic_arn = aws_sns_topic.instance_profile_abnormally_used.arn
  protocol  = "email"
  endpoint  = var.user_email
}