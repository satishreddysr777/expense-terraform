resource "aws_db_parameter_group" "main" {
  name = "rds-pg"
  family = var.family

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "default" {
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.dbname
  engine                  = var.engine
  engine_version          = var.engine_version
  username                = var.username
  password                = var.password
  parameter_group_name    = aws_db_parameter_group.main.name
  skip_final_snapshot     = true
}