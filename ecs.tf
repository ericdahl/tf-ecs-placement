data "template_file" "ecs_user_data" {
  template = "${file("templates/ecs-user-data.sh")}"
}

data "template_file" "ecs_special_user_data" {
  template = "${file("templates/ecs-special-user-data.sh")}"
}

resource "aws_instance" "ecs1" {
  ami = "${var.ami_ecs}"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"

  tags {
    Name = "ecs1"
  }
}

resource "aws_instance" "ecs2" {
  ami = "${var.ami_ecs}"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet2.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"

  tags {
    Name = "ecs2"
  }
}

resource "aws_instance" "ecs3" {
  ami = "${var.ami_ecs}"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet3.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"

  tags {
    Name = "ecs3"
  }
}

resource "aws_instance" "ecs_special_1" {
  ami = "${var.ami_ecs}"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet3.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_special_user_data.rendered}"

  tags {
    Name = "ecs_special_1"
    Special = "true"
  }
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
  task_definition = "${aws_ecs_task_definition.nginx.arn}"
  desired_count = "${var.count}"

  iam_role = "${aws_iam_role.ecs_service.name}"

  placement_strategy {
    type = "spread"
    field = "attribute:ecs.availability-zone"
  }

  placement_strategy {
    type = "binpack"
    field = "memory"
  }

  placement_constraints {
    type = "memberOf"
    expression = "attribute:Special == true"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    container_name = "nginx"
    container_port = 80
  }

}

resource "aws_alb" "default" {
  subnets = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}", "${aws_subnet.subnet3.id}"]

  security_groups = ["${aws_security_group.alb.id}"]
}

resource "aws_alb_listener" "default" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.default.arn}"
  port = 80
}

resource "aws_alb_target_group" "default" {
  vpc_id = "${aws_vpc.default.id}"
  port = 80
  protocol = "HTTP"
}


