terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

# Create S3 bucket
resource "aws_s3_bucket" "mys3bucket" {
  bucket = "amitkumar0441bucket"  # Ensure the bucket name is a string
}
