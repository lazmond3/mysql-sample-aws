resource "aws_db_subnet_group" "main" {
  name = "db"
  subnet_ids = [
    # aws_subnet リソースで作成したサブネットを指定する。
    # マルチAZを使用するため、異なるAZに所属しているサブネットを指定します。
    # var.subnet_id_private_db_a,
    aws_subnet.twitter_db_subnet_1a.id,
    aws_subnet.twitter_db_subnet_1c.id,
    # var.subnet_id_private_db_c
  ]

  tags = {
    Env = "dev"
  }
}
