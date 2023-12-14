data "aws_iam_policy_document" "cloudtrail_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_role_inline_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:${data.aws_caller_identity.aws-account-id.account_id}:log-group:${aws_cloudwatch_log_group.main.name}:log-stream:*", ]
  }
}


resource "aws_iam_role" "cloudtrail_role" {
  name               = "cloudtrail_role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role_policy.json
  inline_policy {
    name   = "policy-8675309"
    policy = data.aws_iam_policy_document.cloudtrail_role_inline_policy.json
  }
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "335e03d7-5a39-4331-bd60-e74b313816d6"
    Owner     = "RGA"
  }
}

resource "aws_cloudtrail" "cloudgoat_trail" {
  name                          = "cloudgoat-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail         = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  // CloudTrail requires the Log Stream wildcard for the parameter below
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.main.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "7bb9c6cc-734d-4ffc-aab0-9a9124bc7c16"
    Owner     = "RGA"
  }
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket        = "cloudgoat-cloudtrail-logs-${replace(var.cgid, "_", "-")}"
  force_destroy = true
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "deeac0da-279d-4b63-8a5f-186ef65bd000"
    Owner     = "RGA"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.cloudtrail_logs.id
  policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AWSCloudTrailAclCheck",
                "Effect": "Allow",
                "Principal": {
                "Service": "cloudtrail.amazonaws.com"
                },
                "Action": "s3:GetBucketAcl",
                "Resource": "arn:aws:s3:::${aws_s3_bucket.cloudtrail_logs.bucket}"
            },
            {
                "Sid": "AWSCloudTrailWrite",
                "Effect": "Allow",
                "Principal": {
                "Service": "cloudtrail.amazonaws.com"
                },
                "Action": "s3:PutObject",
                "Resource": "arn:aws:s3:::${aws_s3_bucket.cloudtrail_logs.bucket}/prefix/AWSLogs/${data.aws_caller_identity.aws-account-id.account_id}/*",
                "Condition": {
                    "StringEquals": {
                        "s3:x-amz-acl": "bucket-owner-full-control"
                    }
                }
            }
        ]
    }
    POLICY
}

