provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_security_group" "terraform" {
  name = "terraform"
  description = "Used in the terraform"
  vpc_id = "${aws_vpc.default.id}"

  # SSH 
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0" ]
  }

  # HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_subnet_cidr}"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.vpc_subnet_cidr}"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.vpc_name} private network"
  }
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "default" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.default.id}"
}
resource "aws_instance" "web" {
  tags {
    Name = "web"
  }

  # select AWS instance type
  instance_type = "${var.aws_instance_type}"

  # Select which AMI to use for the specific region
  ami = "${lookup(var.aws_ami, var.aws_region)}"

  # Storage settings
  root_block_device {
    delete_on_termination = true
    volume_size = 50
  }

  security_groups = ["${aws_security_group.terraform.id}" ]

  subnet_id = "${aws_subnet.private.id}"

  # the name of the SSH keypair in the AWS console
  key_name = "${var.key_name}"

  connection {
    user = "admin"
    key_file = "${var.key_path}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apache2",
      "sudo service apache2 restart"
    ]
  }
}

