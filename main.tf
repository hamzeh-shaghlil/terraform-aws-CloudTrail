data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  bucket_name = "${var.account_name}-cloudtrail"
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
}


data "template_file" "kms_policy" {
  template = file("./templates/kmsPolicy.json")
  vars = {
    account_id = local.account_id
  }
}

resource "aws_kms_key" "cloudtrail" {
  description             = "CloudTrail Key"
  deletion_window_in_days = 10
  policy                  = data.template_file.kms_policy.rendered
}

data "template_file" "s3_bucket_policy" {
  template = file("./templates/s3BucketPolicy.json")
  vars = {
    bucket_name = local.bucket_name
    account_id  = local.account_id
  }
}


resource "aws_s3_bucket" "cloudtrail" {
  bucket = local.bucket_name
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  force_destroy = true
  policy        = data.template_file.s3_bucket_policy.rendered
}

resource "aws_cloudwatch_log_group" "cloud_trail_log_group" {
  name              = "CloudTrailLogGrp"
  retention_in_days = 0
}

resource "aws_cloudwatch_log_stream" "cloud_trail_log_stream" {
  name           = "${local.account_id}_CloudTrail_${local.region}"
  log_group_name = aws_cloudwatch_log_group.cloud_trail_log_group.name
}

data "template_file" "cloud_trail_log_role_policy" {
  template = file("./templates/cloudWatchRolePolicy.json")
  vars = {
    region         = local.region
    account_id     = local.account_id
    log_group_name = aws_cloudwatch_log_group.cloud_trail_log_group.name
  }
}

resource "aws_iam_role" "cloud_watch_logs_role" {
  name = "CloudTrailRoleForCloudWatchLogs"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      },
    ]
  })
  inline_policy {
    name   = "CloudTrailPolicyForCloudWatch"
    policy = data.template_file.cloud_trail_log_role_policy.rendered
  }
}

resource "aws_cloudtrail" "trail" {
  name                          = var.account_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloud_watch_logs_role.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloud_trail_log_group.arn}:*"
}


resource "aws_cloudformation_stack" "cloud_watch_alarms" {
  name = "CloudWatchSecurityAlarms"
  parameters = {
    CloudTrailLogGroup = aws_cloudwatch_log_group.cloud_trail_log_group.name
    Email              = var.email
  }
  template_body = file("./templates/securityAlarmsMetricFilters.yaml")
  depends_on = [
    aws_cloudtrail.trail
  ]
}
