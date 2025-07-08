resource "aws_secretsmanager_secret" "mysql" {
  name = "devops/mysql"
}
resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id     = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({ DB_USER = "admin", DB_PASS = "password" })
}
