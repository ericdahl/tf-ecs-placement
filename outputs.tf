output "instance.public_ip" {
  value = "${aws_instance.default.public_ip}"
}

output "ecs1.public_ip" {
  value = "${aws_instance.ecs1.public_ip}"
}

output "ecs2.public_ip" {
  value = "${aws_instance.ecs2.public_ip}"
}

output "ecs3.public_ip" {
  value = "${aws_instance.ecs3.public_ip}"
}

output "alb" {
  value = "${aws_alb.default.dns_name}"
}