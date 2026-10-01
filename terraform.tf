terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-remote-state-bucket-0207" # Name of your S3 bucket
    key            = "terraform.tfstate"                  # File path inside the bucket
    region         = "ap-south-1"                         # AWS Region
    dynamodb_table = "terraform-remote-state-table"       # Name of your DynamoDB table
  }
}


# This code needs to be inserted in main.tf file.