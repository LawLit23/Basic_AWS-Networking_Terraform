variable "os" {
  type        = string
  default     = "ami-053b05"
  description = "This is AMI ID"
}

variable "size" {
  default     = "t2.micro"
  description = "This is ECS"
}

variable "tag" {
  type    = string
  default = "This is my ECS instance"
}

variable "bucket_name" {
  default = "mybucket42345"

}
