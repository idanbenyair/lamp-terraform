output "aws_instance" {
  value = "${aws_instance.qa_app.private_ip}"
  description = "The AMI thats been used"
}

output "elb_name" {
  value = "${aws_elb.qa_elb.dns_name}"
  description = "ELB DNS name"
}

output "db_endpoint" {
  value = "${aws_db_instance.mysql_db.endpoint}"
}

