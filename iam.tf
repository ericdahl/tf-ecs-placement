resource "aws_iam_role" "ec2_role" {
  name = "tf-ecs-example-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "default" {
  name = "${var.name}-ec2"
  roles = ["${aws_iam_role.ec2_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "default" {
  name = "${var.name}-instance-profile"
  role = "${aws_iam_role.ec2_role.name}"
}



resource "aws_iam_role" "ecs_service" {
  name = "tf-ecs-example-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_service" {
  name = "${var.name}-ecs-service"
  roles = ["${aws_iam_role.ecs_service.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
