variable "os" {
  type        = string
  default     = "ami-04f167a56786e4b09"
  description = "This is AMI ID"
}

variable "size" {
  default     = "t2.micro"
  description = "This is t2 micro"
}

variable "tag" {
  type    = string
  default = "Ubuntu.1"
}

variable "bucket_name" {
  default = "somebucket55885"

}
variable "server_port" {
  default     = 8080
  description = "The port that the server will use to handle HTTP requests"
  type        = number

}

variable "cidr_block" {
  default = "10.210.0.0/16"
  type    = string

}

variable "subnet_cidr_block_public" {
  default = "10.210.10.0/24"
  type    = string

}

variable "subnet_cidr_block_private" {
  default = "10.210.200.0/24"
  type    = string

}

variable "vpc_name" {
  default = "Law_vpc"
  type    = string

}

