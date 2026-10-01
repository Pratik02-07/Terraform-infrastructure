# key pair 
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# vpc & security group
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# security group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "Allow SSH and HTTP, this will add a TF generated security group."
  vpc_id      = aws_default_vpc.default.id

  # inbound rules - ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  # outbound rules - egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic access from anywhere open outbounds"
  }
}


# ec2 instance
resource "aws_instance" "my_instance" {
  #meta argument 
  # count = 2 

  for_each = tomap({
    automate-micro = "t3.micro"
    automate-small = "t3.small"

  })

  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]


  ami                    = var.ec2_ami_id # Ubuntu  - interpollate the variable for AMI ID
  instance_type          = each.value     #var.ec2_instance_type # CHANGED: Use t3.micro for ap-south-1 Free Tier
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  user_data = file("install_nginx.sh") # Configure the instance with a script to install Nginx



  # conditional Expression for root_block_device volume_size based on environment variable
  # If environment is "prod", use 15GB. Otherwise, use the default root storage size.

  root_block_device {
    # volume_size = var.ec2_root_storage_size
    volume_size = var.env == "prod" ? 15 : var.ec2_default_root_storage_size
    volume_type = var.ec2_root_storage_type
  }


  tags = {
    Name = "Terraform-EC2-${each.key}"
    # Name = "Terraform-EC2-${count.index + 1}"
    # Name = "Terraform-EC2"
  }
}

