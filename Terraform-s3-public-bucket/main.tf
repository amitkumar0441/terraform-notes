terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Create the S3 bucket
resource "aws_s3_bucket" "mys3bucket" {
  bucket = "amitkumar0441bucket"
}

# Disable S3 block public access settings (to allow public access)
resource "aws_s3_bucket_public_access_block" "mys3bucket_public_access" {
  bucket = aws_s3_bucket.mys3bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Generate the public access bucket policy using a data source
data "aws_iam_policy_document" "public_read_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.mys3bucket.arn}/*", # Allow access to all objects in the bucket
    ]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"] # Allow everyone (public)
    }
  }
}

# Attach the generated public read access policy to the S3 bucket
resource "aws_s3_bucket_policy" "mys3bucket_policy" {
  bucket = aws_s3_bucket.mys3bucket.id
  policy = data.aws_iam_policy_document.public_read_policy.json
}
