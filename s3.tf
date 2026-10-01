# #create a new file s3.tf

# # Create S3 bucket
# resource "aws_s3_bucket" "my_bucket" {
#   bucket = "terraform-in-one-shot-0207" 
# }

# # Output bucket name
# output "bucket_name" {
#   value = aws_s3_bucket.my_bucket.bucket
# }