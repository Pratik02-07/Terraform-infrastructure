terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Change this from "~> 5.0" to allow version 6.x
    }
  }
}
