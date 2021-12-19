resource "aws_db_parameter_group" "main" {
  name = "main"

  # DBパラメータグループが適用されるファミリーを設定する。
  #  - 今回は、MySQL8.0を使用する。
  family = "mysql8.0"

  # スロークエリログを有効にする。
  parameter {
    name  = "slow_query_log"
    value = 1
  }

  # 一般クエリログを有効にする。
  parameter {
    name  = "general_log"
    value = 1
  }

  # スロークエリと判断する秒数を設定する。
  parameter {
    name  = "long_query_time"
    value = 1
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"

  }
}

resource "aws_db_option_group" "main" {
  name = "main"

  # DBインスタンスに使用するエンジンを設定する。
  #  - MySQLを設定。
  engine_name = "mysql"

  # エンジンのメジャーバージョンを設定する。
  #  - MySQL8.0のため、「8.0」を設定する。
  major_engine_version = "8.0"
}