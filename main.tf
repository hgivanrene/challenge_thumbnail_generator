// Define the necesary providers for this terraform project. Provider HashiCorp in its version 4.36.1.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.0"
}

# Set up AWS provider. Use the variable aws_region from the variable file.
provider "aws" {
  region = var.aws_region
}

//Create original and Thumbnail S3 buckets.
resource "aws_s3_bucket" "thumbnail_input_image_bucket_hg" {
  bucket = "input-image-bucket-hg01"
}

resource "aws_s3_bucket" "thumbnail_image_bucket_hg" {
  bucket = "thumbnail-image-bucket-hg01"
}

//Setting the policy of Get original and Put object Thumbnail.
resource "aws_iam_policy" "thumbnail_s3_policy" {
  name = "thumbnail_s3_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : "s3:GetObject",
      "Resource" : "arn:aws:s3:::input-image-bucket-hg01/*"
      }, {
      "Effect" : "Allow",
      "Action" : "s3:PutObject",
      "Resource" : "arn:aws:s3:::thumbnail-image-bucket-hg01/*"
    }, {
      "Effect" : "Allow",
      "Action" : "s3:ListBucket",
      "Resource" : "*"
      }]
  })
}

//Lambda IAM Role to assume the role
resource "aws_iam_role" "thumbnail_lambda_role" {
  name = "thumbnail_lambda_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

//IAM Policy Attachment, role for s3 and role for lambda
resource "aws_iam_policy_attachment" "thumbnail_role_s3_policy_attachment" {
  name       = "thumbnail_role_s3_policy_attachment"
  roles      = [aws_iam_role.thumbnail_lambda_role.name]
  policy_arn = aws_iam_policy.thumbnail_s3_policy.arn
}

resource "aws_iam_policy_attachment" "thumbnail_role_lambda_policy_attachment" {
  name       = "thumbnail_role_lambda_policy_attachment"
  roles      = [aws_iam_role.thumbnail_lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.thumbnail_input_image_bucket_hg.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.thumbnail_input_image_bucket_hg.arn}/*"
      }
    ]
  })
}

//Configuration to zip the lambda file to upload “my-lambda-code.zip”
data "archive_file" "thumbnail_lambda_source_archive" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code"
  output_path = "${path.module}/my-lambda-code.zip"
}

resource "aws_lambda_function" "thumbnail_lambda" {
  function_name = "thumbnail_generation_lambda_hg"
  filename      = "${path.module}/my-lambda-code.zip"

  runtime     = "python3.9"
  handler     = "aws_lambda.lambda_function"
  memory_size = 256

  source_code_hash = data.archive_file.thumbnail_lambda_source_archive.output_base64sha256

  role = aws_iam_role.thumbnail_lambda_role.arn

  layers = ["arn:aws:lambda:${var.aws_region}:770693421928:layer:Klayers-p39-pillow:1"]
}

//Setting lambda permission to Thumbnail bucket to put the thumbnail.
resource "aws_lambda_permission" "thumbnail_allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.thumbnail_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.thumbnail_input_image_bucket_hg.arn
}

resource "aws_s3_bucket_notification" "thumbnail_notification" {
  bucket = aws_s3_bucket.thumbnail_input_image_bucket_hg.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumbnail_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.thumbnail_allow_bucket
  ]
}

//Cloudwatch monitoring and logs
resource "aws_cloudwatch_log_group" "thumbnail_cloudwatch_hg" {
  name = "/aws/lambda/${aws_lambda_function.thumbnail_lambda.function_name}"

  retention_in_days = 30
}