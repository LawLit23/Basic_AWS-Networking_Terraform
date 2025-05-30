# Key Pair
resource "aws_key_pair" "my_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key)
  tags = {
    Name = "my_auth"
  }
}


#EC2 instances
resource "aws_instance" "web" {
  ami                         = var.os
  instance_type               = var.size
  vpc_security_group_ids      = [aws_security_group.web.id] # Needs to link resource to Security group
  subnet_id                   = aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my_auth.id
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name # Attaching role to EC2 Instance

  user_data = file("userdata.tpl")

  tags = {
    Name = var.tag
  }
}
