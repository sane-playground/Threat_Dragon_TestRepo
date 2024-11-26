provider "aws" {
  region = "us-west-2"
}

# Publicly accessible S3 bucket (Vulnerability: S3 bucket allows public read access)
resource "aws_s3_bucket" "public_bucket" {
  bucket = "example-public-bucket"
  acl    = "public-read"  # Misconfiguration: Publicly readable bucket
}

# Security Group with open ingress (Vulnerability: Unrestricted ingress)
resource "aws_security_group" "insecure_sg" {
  name        = "insecure-sg"
  description = "Security group with open ingress"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Misconfiguration: Open to the world
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance without encryption on root volume (Vulnerability: Unencrypted EBS volume)
resource "aws_instance" "unencrypted_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 8
    encrypted   = false  # Misconfiguration: Unencrypted root volume
  }
}

# RDS database without storage encryption (Vulnerability: RDS encryption disabled)
resource "aws_db_instance" "insecure_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  name                 = "exampledb"
  username             = "admin"
  password             = "password"
  skip_final_snapshot  = true
  publicly_accessible  = true  # Misconfiguration: Publicly accessible database
  storage_encrypted    = false  # Misconfiguration: Storage encryption disabled
}
