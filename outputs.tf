output "instance.public_ip" {
  value = "${aws_instance.default.public_ip}"
}

output "ecs1.public_ip" {
  value = "${aws_instance.ecs1.public_ip}"
}