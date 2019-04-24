
resource "aws_security_group" "sg" {

  name = "${var.sg_name}"
  description = "Allow traffic over port 80"
  vpc_id = "vpc-36c0f850"

  lifecycle {
  create_before_destroy = true
}

  ingress {

  from_port = "${var.port_in}"
  to_port = "${var.port_in}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

  ingress {

  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

  egress {

  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}
}

