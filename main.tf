provider "aws" {
  region = "us-east-1"
}

variable "name" {
  default = "tf-ecs-placement"
}

resource "aws_instance" "default" {
  instance_type = "t2.micro"
  ami = "ami-a4c7edb2"
  vpc_security_group_ids = [
    "${aws_security_group.default.id}"]


  subnet_id = "${aws_subnet.subnet1.id}"

  key_name = "${var.key}"
}

