provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region     = "us-east-1"
}

module "ec2_sg" {
  source = "/home/centos/terraform/lamp/modules/aws-sgs"
  sg_name = "ec2_sg"
}

module "elb_sg" {
  source = "/home/centos/terraform/lamp/modules/aws-sgs"
  sg_name = "elb_sg"
}

module "mysql_db" {
  source = "/home/centos/terraform/lamp/modules/datebases"
}

#locals {
#ec2_sg_id = concat(aws_security_groups.ec2_sg.id, aws_security_groups.elb_sg.id)
#}

#resource "aws_db_instance" "mysql_db" { 
#  allocated_storage = 20
#  storage_type = "gp2"
#  engine = "mysql"
#  engine_version = "5.7"
#  instance_class = "db.t2.micro"
#  name = "testdb"
#  username = "dbuser"
#  password = "12FLoz355"
#  parameter_group_name = "default.mysql5.7"
#  identifier = "wordpress-db-qa"
#  final_snapshot_identifier = "final-snapshot"
#  skip_final_snapshot = true
#}

resource "aws_instance" "qa_app" {
  ami           = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${var.private_key}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${module.ec2_sg.sg_id}"]
  provisioner "remote-exec" {  

    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "sudo chown centos:centos /var/www/html/"
    ]
    connection = {
      type = "ssh"
      user = "centos"
      private_key = "${file("${var.private_key_path}")}"
  }
 }
  provisioner "file" {
    source = "files/index.html"
    destination = "/var/www/html/index.html"
    
    connection = {
     type = "ssh"
     user = "centos"
     private_key = "${file("${var.private_key_path}")}"
  }
 }
}

resource "aws_elb" "qa_elb" {

  name = "qa-elb"
  subnets = ["${var.subnet_id}"]
  security_groups = ["${module.elb_sg.sg_id}"]
  listener {
    instance_port = "80"
    instance_protocol = "http"
    lb_port = "80"
    lb_protocol = "http"
}

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
}
  instances = ["${aws_instance.qa_app.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
}

