# Create VPC

resource "aws_vpc" "base_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "${var.tag_name}_vpc" }
}
#---------------------------------------------------------------------------------------

#Create a subnet
#---------------------------------------------------------------------------------------
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.base_vpc.id
  cidr_block              = var.subnet_cidr_block_public_1[0]
  availability_zone       = var.vpc_az_1[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.tag_name}_Public_Subnet 1" }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.base_vpc.id
  cidr_block        = var.subnet_cidr_block_private_1[0]
  availability_zone = var.vpc_az_2
  tags              = { Name = "${var.tag_name}_Private_Subnet 1" }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.base_vpc.id
  cidr_block              = var.subnet_cidr_block_public_1[1]
  availability_zone       = var.vpc_az_1[1]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.tag_name}_Public_Subnet 2" }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.base_vpc.id
  cidr_block        = var.subnet_cidr_block_private_1[1]
  availability_zone = var.vpc_az_2
  tags              = { Name = "${var.tag_name}_Private_Subnet 2" }
}
#---------------------------------------------------------------------------------------
#Create a internet gateway

resource "aws_internet_gateway" "base_IG" {
  vpc_id = aws_vpc.base_vpc.id

  tags = { Name = "${var.tag_name}_IG" }
}
#---------------------------------------------------------------------------------------
# Create a public and private route table

resource "aws_route_table" "base_route_table_public" {
  vpc_id = aws_vpc.base_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base_IG.id
  }

  tags = { Name = "${var.tag_name}_Public_RT" }
}
##########################
# Private route table
resource "aws_route_table" "base_route_table_private" {
  vpc_id = aws_vpc.base_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = { Name = "${var.tag_name}_Private_RT" }
}

#---------------------------------------------------------------------------------------

#Create a route table association | Public RT with Public Subnet
resource "aws_route_table_association" "public_subnet_association1" {
  route_table_id = aws_route_table.base_route_table_public.id
  subnet_id      = aws_subnet.public_subnet1.id

}

resource "aws_route_table_association" "private_subnet_association1" {
  route_table_id = aws_route_table.base_route_table_private.id
  subnet_id      = aws_subnet.private_subnet1.id

}

resource "aws_route_table_association" "public_subnet_association2" {
  route_table_id = aws_route_table.base_route_table_public.id
  subnet_id      = aws_subnet.public_subnet2.id

}

resource "aws_route_table_association" "private_subnet_association2" {
  route_table_id = aws_route_table.base_route_table_private.id
  subnet_id      = aws_subnet.private_subnet2.id

}
#---------------------------------------------------------------------------------------

# Elastic IP EIP

resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.base_IG]
}
#---------------------------------------------------------------------------------------

# NAT Gateway

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public_subnet1.id
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_internet_gateway.base_IG]
  tags          = { Name = "${var.tag_name}_NAT_Gateway" }

}

#---------------------------------------------------------------------------------------


# Launch configuration

# resource "aws_launch_configuration" "web_auto" {
#   image_id        = var.os
#   instance_type   = var.size
#   security_groups = [aws_security_group.web8080.id]

#   user_data = <<-EOF
#   #!/bin/bash
#   echo "Hello, World" > index.html
#   nohup busybox httpd -f -p ${var.server_port} &
#   EOF

#   # Lifecycle is required when using ASG | It creates the new config before destroying old resource 
#   lifecycle {
#     create_before_destroy = true
#   }

# }


# Auto Scaling Group | ASG

# resource "aws_autoscaling_group" "web-ASG" {
#   launch_configuration = [aws_launch_configuration.web_auto]
#   name                 = "web"
#   availability_zones   = ["us-east-1a"]
#   desired_capacity     = 3
#   max_size             = 10
#   min_size             = 2
#   health_check_type    = "ELB"
#   launch_template {
#     id      = aws_launch_template.web_auto.id
#     version = "$Latest"
#   }
#   target_group_arns = [aws_lb_target_group.asg.arn]
# }



# #S3 Bucket


# resource "aws_s3_bucket" "bucket" {
#   bucket = "${var.bucket_name}thebyang"
# }


# Security group

resource "aws_security_group" "web" {
  name        = "allow_web8080"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.base_vpc.id

  ingress {
    description = "web traffic from VPC"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "web traffic from VPC"
    from_port   = var.server_port_apache
    to_port     = var.server_port_apache
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh traffic from VPC"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
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

