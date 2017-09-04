data "template_file" "ecs_user_data" {
  template = "${file("templates/ecs-user-data.sh")}"
}
resource "aws_instance" "ecs1" {
  ami = "ami-04351e12"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"
}

resource "aws_instance" "ecs2" {
  ami = "ami-04351e12"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.subnet2.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "${var.key}"

  iam_instance_profile = "${aws_iam_instance_profile.default.name}"

  user_data = "${data.template_file.ecs_user_data.rendered}"
}

resource "aws_instance" "ecs3" {
  ami = "ami-04351e12"
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

//data "template_file" "graphite" {
//  template = "${file("templates/tasks/graphite.json")}"
//}
//
//resource "aws_ecs_task_definition" "graphite" {
//  container_definitions = "${data.template_file.graphite.rendered}"
//  family = "${var.name}-graphite-family"
//}
//
//resource "aws_ecs_service" "graphite" {
//  cluster = "${aws_ecs_cluster.default.id}"
//  name = "${var.name}-graphite"
//  task_definition = "${aws_ecs_task_definition.graphite.id}"
//  desired_count = 1
//
//  load_balancer {
//    target_group_arn = "${aws_alb_target_group.default.arn}"
//    container_name = "graphite"
//    container_port = 2003
//  }
//
//  iam_role = "${aws_iam_role.ecs_service.arn}"
//}
//
//
//resource "aws_security_group" "sg_graphite" {
//  vpc_id = "${aws_vpc.default.id}"
//
//  ingress {
//    protocol = "tcp"
//    from_port = 2003
//    to_port = 2003
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//
//  egress {
//    protocol = "-1"
//    from_port = 0
//    to_port = 0
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}
//
//
//resource "aws_alb" "default" {
//  subnets = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}", "${aws_subnet.subnet3.id}"]
//
//  security_groups = ["${aws_security_group.sg_graphite.id}"]
//}
//
//resource "aws_alb_listener" "default" {
//  "default_action" {
//    target_group_arn = "${aws_alb_target_group.default.arn}"
//    type = "forward"
//  }
//  load_balancer_arn = "${aws_alb.default.arn}"
//  port = 2003
//}
//
//resource "aws_alb_target_group" "default" {
//  port = 2003
//  protocol = "HTTP"
//  vpc_id = "${aws_vpc.default.id}"
//
//  health_check {
//
//  }
//}
