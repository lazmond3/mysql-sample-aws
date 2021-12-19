terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-bucket-twitter-db-mysql"
    key    = "tfstate-bucket-twitter-db-mysql/dev.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# これは使わない
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
