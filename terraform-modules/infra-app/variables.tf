variable "env" {
  description = "This is the env for my infra"
  type        = string
}
variable "bucket_name" {
  description = "This is the name of the bucket"
  type        = string
}
# ec2 instance variables
variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "ec2_ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "ec2_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "ec2_root_storage_type" {
  description = "The root storage size for the EC2 instance"
  type        = string
}
# -------------------------------------------------
# dynamodb table hash key variable
variable "hash_key" {
  description = "The hash key for the DynamoDB table"
  type        = string
}
