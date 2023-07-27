# Step 1: Config the Service Provider
provider "aws" {
  version = "1.0'
  region = "ap-southeast-1"
}

# Step 2: Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Step 3: 
# Step 3.a) Create 2 Public Subnet under main VPC

resource "aws_subnet" "public-sub-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "public-sub"
  }
}

resource "aws_subnet" "public-sub-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "public-sub"
  }
}

# Step 3.b) Create 2 Public Subnet under main VPC

resource "aws_subnet" "private-sub-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "private-sub"
  }
}

resource "aws_subnet" "private-sub-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "private-sub"
  }
}

data "aws_subnets" "sub-id" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }

  tags = {
    Tier = "public"
  }
}
