output "db_endpoint" {
  value = aws_db_instance.mariadb.endpoint
}

output "db_port" {
  value = aws_db_instance.mariadb.port
}