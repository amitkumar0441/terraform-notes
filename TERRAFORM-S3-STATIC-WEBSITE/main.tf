terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.89.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 1) Create a S3 bucket:
resource "aws_s3_bucket" "mys3bucket" { 
  bucket = var.bucketname
}

# 2) Create S3 bucket public access settings:
resource "aws_s3_bucket_public_access_block" "mys3bucket_public_access" {
  bucket = aws_s3_bucket.mys3bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Generate the public access bucket policy:
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

# Attach the generated public read access policy to the S3 bucket:
resource "aws_s3_bucket_policy" "mys3bucket_policy" {
  bucket = aws_s3_bucket.mys3bucket.id
  policy = data.aws_iam_policy_document.public_read_policy.json
}

# 3) Upload objects to the S3 bucket:-
resource "aws_s3_object" "index" {
  bucket = var.bucketname
  key    = "index.html"
  source = "index.html"
  depends_on = [aws_s3_bucket.mys3bucket]

}

resource "aws_s3_object" "error" {
  bucket = var.bucketname
  key    = "error.html"
  source = "error.html"
  depends_on = [aws_s3_bucket.mys3bucket]
}

# 4) Create static website configuration for the S3 bucket:-
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.mys3bucket.id  # Corrected to refer to mys3bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
