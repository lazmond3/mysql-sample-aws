terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "tfstate-bucket-twitter-db-mysql" {
  bucket = "tfstate-bucket-twitter-db-mysql"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "tfstate-bucket-twitter-db-mysql/tfstate"
  }
}
