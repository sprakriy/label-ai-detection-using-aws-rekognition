terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "label-bkt-for-ai-04282026"
    key            = "rekognition-pipeline/terraform.tfstate"
    region         = "us-east-1"
    # Use DynamoDB for state locking if you want to be extra professional
    # dynamodb_table = "terraform-state-locking"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}