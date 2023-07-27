# Terraform version & Service Provider source code using Delarative Method

terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.0"
   }
 }
}

# Step 1: Config the Service Provider
provider "aws" {
  version = "2.0'
  region = "ap-southeast-1"
}

# Step 2: Create VPC
resource "aws_vpc" "customvpc" {
  cidr_block = "10.0.0.0/16"
}

# Step 3: 
# Step 3.a) Create 2 Public Subnet under custom VPC

resource "aws_subnet" "public-sub-a" {
  vpc_id     = aws_vpc.customvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "public-sub"
  }
}

resource "aws_subnet" "public-sub-b" {
  vpc_id     = aws_vpc.customvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "public-sub"
  }
}

# Step 3.b) Create 2 Public Subnet under custom VPC

resource "aws_subnet" "private-sub-a" {
  vpc_id     = aws_vpc.customvpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "private-sub"
  }
}

resource "aws_subnet" "private-sub-b" {
  vpc_id     = aws_vpc.customvpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "private-sub"
  }
}

# Filter Subnets under custom VPC and tag as public
data "aws_subnets" "sub-id" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.customvpc.id]
  }

  tags = {
    Tier = "public"
  }
}

# Step 4: Create Security Group custom
resource "aws_security_group" "allow_tls_custom" {
  name        = "allow_tls_custom"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.customvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls_custom"
  }
}

# Step 5.a): Create EC2 Template
resource "aws_launch_template" "aws-ec2-custom-template" {
  name = "aws-ec2-custom-template"
  key_name = "ec2-mgt-key"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }

  instance_type           = "t2.micro"
  ami                     = "ami-0acb5e61d5d7b19c8"
  subnet_id = aws_subnet.public-sub-[count.index].id
  vpc_security_group_ids  = [aws_security_group.allow_tls_custom.id]
  associate_public_ip_address = true

}

# Step 5.b) Create Static EC2 Instance
resource "aws_instance" "appserver" {
  ami           = "ami-0acb5e61d5d7b19c8"
  instance_type = "t2.micro"
  key_name = "ec2-mgt-key"
  subnet_id = aws_subnet.public-sub-[count.index].id
  vpc_security_group_ids = [aws_security_group.allow_tls._custom.id]
  associate_public_ip_address = true

  }

# Step 6: Create Internet Gateway
resource "aws_internet_gateway" "custom-internet-gw" {
  vpc_id = aws_vpc.customvpc.id

  tags = {
    Name = "custom"
  }
}

# Step 7: Create Elastic IP for Custom
resource "aws_eip" "custom-eip" {
  vpc = true
}

# Step 8: Create NAT Gateway to allow Internet traffic for Public subnets

/*
resource "aws_nat_gateway" "custom-natgw" {
  allocation_id = aws_eip.custom-eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NAT GW"
  } */

data "aws_nat_gateways" "custom-natgws" {
  vpc_id = aws_vpc.customvpc.id

  filter {
    name   = "state"
    values = ["available"]
  }
  tags = {
    Name = "NAT GW"
  }
}

data "aws_nat_gateway" "custom-ngw" {
  count = length(data.aws_nat_gateways.custom-natgws.ids)
  id    = tolist(data.aws_nat_gateways.custom-natgws.ids)[count.index]

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateways.custom-internet-gw]
}

# Step 9: Custom Route Policy allow Public subnet to Internet Gateway

resource "aws_route_table" "custom-routetb" {
  vpc_id = aws_vpc.customvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "custom-route-tb"
  }
}

resource "aws_route_table_association" "custom-route-tb-ass" {
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.custom-routetb.id
  //count = 2
}

// Adding NAT Gateway into the default Custom route table to Private subnet
resource "aws_default_route_table" "defaultrtb" {
  default_route_table_id = aws_vpc.customvpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom-ngw.id
  }

  tags = {
    Name = "custom2default-route-tb"
  }
}

# Step 10: Network ACL Ingress/Egress rules across custom VPC

resource "aws_network_acl" "custom_nacl" {
  vpc_id = aws_vpc.customvpc.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {  //Ephemeral Port
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "custom"
  }
}

resource "aws_network_acl_association" "custom_nacl_ass" {
  network_acl_id = aws_network_acl.custom_nacl.id

  data "aws_subnets" "custom_subnets" {
  filter {
    name   = "tag:public-sub"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "custom_subnet" {
  for_each = toset(data.aws_subnets.custom_subnets.ids)
  id       = each.value
}

  output "subnet_cidr_blocks" {
    value = [for s in data.aws_subnet.custom_subnet : s.cidr_block]
  }
  tags = {
    Name = "custom"
  }
}
