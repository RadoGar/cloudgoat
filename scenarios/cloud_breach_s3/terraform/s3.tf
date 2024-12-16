#Secret S3 Bucket
locals {
  # Ensure the bucket suffix doesn't contain invalid characters
  # "Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-)."
  # (per https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html) 
  bucket_suffix = replace(var.cgid, "/[^a-z0-9-.]/", "-")
}

resource "aws_s3_bucket" "cg-cardholder-data-bucket" {
  bucket        = "cg-cardholder-data-bucket-${local.bucket_suffix}"
  force_destroy = true
  tags = {
    Name        = "cg-cardholder-data-bucket-${local.bucket_suffix}"
    Description = "CloudGoat ${var.cgid} S3 Bucket used for storing sensitive cardholder data."
    Stack       = "${var.stack-name}"
    Scenario    = "${var.scenario-name}"
    git_org     = "RadoGar"
    git_repo    = "cloudgoat"
    yor_trace   = "27ef964d-d320-4168-a23a-f8b63166222a"
    Owner       = "RGA"
    PC          = "warsztaty"
  }
}
resource "aws_s3_bucket_object" "cardholder-data-primary" {
  bucket = "${aws_s3_bucket.cg-cardholder-data-bucket.id}"
  key    = "cardholder_data_primary.csv"
  source = "../assets/cardholder_data_primary.csv"
  tags = {
    Name      = "cardholder-data-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "bac566f6-bf39-4fbb-b9c5-d145fa00b18c"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_s3_bucket_object" "cardholder-data-secondary" {
  bucket = "${aws_s3_bucket.cg-cardholder-data-bucket.id}"
  key    = "cardholder_data_secondary.csv"
  source = "../assets/cardholder_data_secondary.csv"
  tags = {
    Name      = "cardholder-data-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "387ae07f-f041-4281-9ab9-5265c6fde830"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_s3_bucket_object" "cardholder-data-corporate" {
  bucket = "${aws_s3_bucket.cg-cardholder-data-bucket.id}"
  key    = "cardholders_corporate.csv"
  source = "../assets/cardholders_corporate.csv"
  tags = {
    Name      = "cardholder-data-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "33c40597-2dac-47bb-a8f2-7cce93906634"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}
resource "aws_s3_bucket_object" "goat" {
  bucket = "${aws_s3_bucket.cg-cardholder-data-bucket.id}"
  key    = "goat.png"
  source = "../assets/goat.png"
  tags = {
    Name      = "cardholder-data-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "d0e4da80-ad5d-4a17-97c3-f7182d8baff6"
    Owner     = "RGA"
    PC        = "warsztaty"
  }
}

resource "aws_s3_bucket_acl" "cardholder-data-bucket-acl" {
  bucket = aws_s3_bucket.cg-cardholder-data-bucket.id
  acl    = "private"
}