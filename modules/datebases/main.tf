resource "aws_db_instance" "mysql_db" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name = "testdb"
  username = "dbuser"
  password = "12FLoz355"
  parameter_group_name = "default.mysql5.7"
  identifier = "wordpress-db-qa"
  final_snapshot_identifier = "final-snapshot"
  skip_final_snapshot = true
}

