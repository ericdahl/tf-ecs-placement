data "template_file" "ecs_user_data" {
  template = "${file("templates/ecs-user-data.sh")}"
}
resource "aws_instance" "ecs1" {
  ami = "ami-9eb4b1e5"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"
}

resource "aws_instance" "ecs2" {
  ami = "ami-9eb4b1e5"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet2.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"
}

resource "aws_instance" "ecs3" {
  ami = "ami-9eb4b1e5"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet3.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"
}

resource "aws_ecs_cluster" "default" {
  name = "${var.name}"
}

data "template_file" "nginx" {
  template = "${file("templates/tasks/nginx.json")}"
}

resource "aws_ecs_task_definition" "nginx" {
  container_definitions = "${data.template_file.nginx.rendered}"
  family = "${var.name}-family"
}

resource "aws_ecs_service" "nginx" {
  cluster = "${aws_ecs_cluster.default.id}"
  name = "${var.name}-nginx"
  task_definition = "${aws_ecs_task_definition.nginx.id}"
  desired_count = 1
}
