# Create VPC

resource "aws_vpc" "base_law" {
  cidr_block = var.cidr_block

  tags = { Name = var.vpc_name }
}

#Create a subnet

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.base_law.id
  cidr_block = var.subnet_cidr_block_public
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.base_law.id
  cidr_block = var.subnet_cidr_block_private
  tags = {
    Name = "private"
  }
}

#Create a internet gateway

resource "aws_internet_gateway" "base_IG" {
  vpc_id = aws_vpc.base_law.id

  tags = {
    Name = "base_IG"
  }
}

#Create a route table
resource "aws_route_table" "base_route_table" {
  vpc_id = aws_vpc.base_law.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base_IG.id
  }

  tags = {
    Name = "base_route_table"
  }
}


#Create a route table association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.base_route_table.id
}

#EC2 instances
resource "aws_instance" "web" {
  ami                    = var.os
  instance_type          = var.size
  vpc_security_group_ids = [aws_security_group.web8080.id] # Needs to link resource to Security group
  subnet_id              = aws_subnet.public.id

  user_data = <<-EOF
  #!/bin/bash
  echo "Hello, World" > index.html
  nohup busybox httpd -f -p ${var.server_port} &
  EOF

  tags = {
    Name = var.tag
  }

}


#S3 Bucket


resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}thebyang"
}


#Security group

resource "aws_security_group" "web8080" {
  name        = "allow_web8080"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.base_law.id

  ingress {
    description = "web traffic from VPC"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web8080"
  }

}

