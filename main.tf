#EC2 instances
resource "aws_instance" "web" {
  ami           = var.os
  instance_type = var.size

  tags = {
    Name = var.tag 
  }

}


#S3 Bucket


resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}_thebyang"
}