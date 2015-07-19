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

