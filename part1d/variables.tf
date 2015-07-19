variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
  description = "Path to the private portion of the SSH key specified."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "eu-west-1"
}

variable "aws_ami" {
  description = "AMI to use (by region)"
  default = {
    eu-west-1 = "ami-971a65e0"
  }
}

variable "aws_instance_type" {
  description = "AWS Instance type to use"
  default = "t1.micro"
}
