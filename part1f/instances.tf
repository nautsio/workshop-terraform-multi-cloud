
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

