provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_instance" "web" {
  tags {
    Name = "web"
  }

  # select AWS instance type
  instance_type = "t1.micro"

  # Select which AMI to use for the specific region
  ami = "ami-e7e66a90"

  # Storage settings
  root_block_device {
    delete_on_termination = true
    volume_size = 50
  }

  # the name of the SSH keypair in the AWS console
  key_name = "${var.key_name}"
}

