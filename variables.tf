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

# variable "bucket_name" {
#   default = "somebucket55885"

#}
variable "server_port" {
  default     = 8080
  description = "The port that the server will use to handle HTTP requests"
  type        = number

}

variable "server_port_apache" {
  default     = 80
  description = "The port that the apache server will use to handle HTTP requests"
  type        = number

}

variable "ssh_port" {
  default     = 22
  description = "The port that the server will use to handle ssh requests"
  type        = number

}

variable "cidr_block" {
  default = "10.0.0.0/16"
  type    = string

}

variable "vpc_az_1" {
  type        = list(string)
  description = "Availability Zones Group 1"
  default     = ["us-east-2a", "us-east-2b"]

}

variable "vpc_az_2" {
  type        = string
  description = "Availability Zone Group 2"
  default     = "us-east-2c"

}

variable "subnet_cidr_block_public_1" {
  default = ["10.0.100.0/24", "10.0.110.0/24"]
  type    = list(string)

}

variable "subnet_cidr_block_private_1" {
  default = ["10.0.200.0/24", "10.0.210.0/24"]
  type    = list(string)

}

variable "tag_name" {
  default = "DaLaw_"
  type    = string

}

variable "public_key" {
  type    = string
  default = "~/.ssh/dalaw_dev_key.pub"

}

variable "key_name" {
  type    = string
  default = "DaLaw Dev Key"
}
