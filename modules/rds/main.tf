resource "aws_db_subnet_group" "rds_subnets" {
  name       = lower("${var.namespace}-rds-subnet-group")
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.namespace}-rds-subnet-group"
  })
}

resource "aws_db_instance" "mariadb" {
  allocated_storage      = 20
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  multi_az               = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = true

  tags = merge(var.tags, {
    Name = "${var.namespace}-mariadb"
  })
}