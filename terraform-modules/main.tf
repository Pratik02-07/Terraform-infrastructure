# dev infra
module "dev-infra" {
  source                = "./infra-app"
  env                   = "dev"
  bucket_name           = "terra-infra-bucket-0207"
  ec2_instance_count    = 1
  ec2_ami_id            = "ami-01a00762f46d584a1"
  ec2_instance_type     = "t3.micro"
  ec2_root_storage_type = "gp3"
  hash_key              = "StudentID"
}


# prd infra
module "prd-infra" {
  source                = "./infra-app"
  env                   = "prd"
  bucket_name           = "terra-infra-bucket-0207"
  ec2_instance_count    = 2
  ec2_ami_id            = "ami-01a00762f46d584a1"
  ec2_instance_type     = "t3.medium"
  ec2_root_storage_type = "gp3"
  hash_key              = "StudentID"
}


# stg infra
module "stg-infra" {
  source                = "./infra-app"
  env                   = "stg"
  bucket_name           = "terra-infra-bucket-0207"
  ec2_instance_count    = 1
  ec2_ami_id            = "ami-01a00762f46d584a1"
  ec2_instance_type     = "t3.small"
  ec2_root_storage_type = "gp3"
  hash_key              = "StudentID"
}
