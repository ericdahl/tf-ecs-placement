resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "%{var.name}"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags {
    Name = "%{var.name}"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags {
    Name = "%{var.name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "default" {
  route_table_id = "${aws_route_table.default.id}"
  subnet_id = "${aws_subnet.subnet1.id}"
}

resource "aws_route_table_association" "sub2" {
  route_table_id = "${aws_route_table.default.id}"
  subnet_id = "${aws_subnet.subnet2.id}"
}

resource "aws_route_table_association" "sub3" {
  route_table_id = "${aws_route_table.default.id}"
  subnet_id = "${aws_subnet.subnet3.id}"
}

resource "aws_security_group" "default" {
  vpc_id = "${aws_vpc.default.id}"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 80

    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}