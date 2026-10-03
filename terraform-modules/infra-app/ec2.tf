# key pair 
resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-infra-app-key" # CHANGED: Use environment variable for key name
  public_key = file("terra-key-ec2.pub")

  tags = {
    Name        = "${var.env}-infra-app-key"
    Environment = var.env
  }
}

# vpc & security group
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# security group
resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-infra-app-sg" # CHANGED: Use environment variable for security group name
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

  # outbound rules - egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic access from anywhere open outbounds"
  }
  tags = {
    Name        = "${var.env}-infra-app-sg"
    Environment = var.env
  }
}


# ec2 instance
resource "aws_instance" "my_instance" {
  count                  = var.ec2_instance_count # CHANGED: Use variable for instance count 
  depends_on             = [aws_security_group.my_security_group, aws_key_pair.my_key]
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]




  # conditional Expression for root_block_device volume_size based on environment variable
  # If environment is "prod", use 15GB. Otherwise, use the default root storage size.

  root_block_device {
    # volume_size = var.ec2_root_storage_size
    volume_size = var.env == "prod" ? 15 : 8
    volume_type = var.ec2_root_storage_type
  }


  tags = {
    Name        = "${var.env}-infra-app-EC2"
    Environment = var.env
  }
}

