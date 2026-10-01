#create a new file s3.tf

# Create S3 bucket
resource "aws_s3_bucket" "remote_s3" {
  bucket = "terraform-remote-state-bucket-0207"
  force_destroy = true # Add this line

  tags = {
    Name = "Terraform Remote State Bucket"
  }
}
