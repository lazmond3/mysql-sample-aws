###########################################
# DB instance
############################################
resource "aws_db_instance" "main" {
  # データベース名。英数字、ハイフンのみ使用可能。
  name = "twitter_db"

  # ストレージタイプ。
  #  - 汎用SSDを使用。IOでより高いパフォーマンスが必要になったらプロビジョンIOPS(io1)の利用を考える。
  storage_type = "gp2"

  # IOPSの設定。ストレージタイプがプロビジョンIOPS(io1)の時指定可能。
  #  - 今回は、ストレージタイプは汎用SSDのため無効。
  # iops                                = 10000

  # 割り当てるストレージのサイズ(GB)。
  #  - 今回は20GBを設定。
  allocated_storage = 20

  # メジャーバージョンのアップデート有無。(例: 9.6 → 9.7)
  #  - 後続で指定するMySQLのメジャーバージョンを使用するため、今回は無効。
  allow_major_version_upgrade = false

  # マイナージョンの自動アップデート有無。(例: 9.6.11 → 9.6.12)
  #  - 自動で行いたいため有効。
  auto_minor_version_upgrade = true

  # RDSへの設定変更を即時反映するかどうかの設定。即時反映しない場合は、次回のメンテナンスウィンドウで反映される。
  # https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/Overview.DBInstance.Modifying.html
  apply_immediately = false

  # バックアップの保持期間(日)。0〜35が指定可能。
  # ※ リードレプリカのソースとして、このインスタンスを使用する場合、0より大きい値を設定する必要がある。
  backup_retention_period = 1

  # 自動バックアップの時間帯(バックアップウィンドウ)の設定。指定した時間帯に毎日実行される。また、メンテナンスウィンドウと被らないように設定する必要がある。時刻はUTC。
  # ※ デフォルトは 13:00〜21:00 の間で30分。(東京リージョンの場合)
  backup_window = "10:00-10:30"

  # メンテナンの実行時間帯(メンテナンスウィンドウ)の設定。この時間帯にOSやデータベースエンジン等のメンテナンスが行われる。時刻はUTC。
  maintenance_window = "Sat:15:00-Sat:16:00"

  # インスタンスに設定されているタグ情報をスナップショットに引き継ぐかどうかの設定。
  #  - 今回はそのまま引き継ぎたいため有効にする。
  copy_tags_to_snapshot = true

  # インスタンスを配置するサブネットグループを設定。
  #  - aws_db_subnet_group を使用する。詳細は後述。
  db_subnet_group_name = aws_db_subnet_group.main.name

  # インスタンスを削除する時にバックアップも削除するかどうかの設定。
  #  - コスト節約のため削除する。
  delete_automated_backups = true

  # データベース削除保護設定。
  #  - Terraform経由で削除したいため無効。
  deletion_protection = false

  # データベースエンジン。
  #  - 今回は「MySQL 8.0」を利用する。
  engine         = "mysql"
  engine_version = "8.0"

  # MySQLの各種ログをCloudWatchに発行するための設定。
  #  - エラーログ、一般ログ、スロークエリログをそれぞれCloudWatchに発行する。
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  # インスタンス削除時にスナップショットの取得をスキップするかどうかの設定。
  #  - コスト節約のためスキップする。
  skip_final_snapshot = true

  # skip_final_snapshot が有効な時、その取得するスナップショットの名称を設定する。
  #  - 今回、skip_final_snapshot は無効なためこの設定も無効。
  # final_snapshot_identifier           = "${var.db_name}-final"

  # データベースアクセスユーザーをIAMで管理するかどうかの設定。
  #  - IAMで管理したいため有効。
  iam_database_authentication_enabled = true

  # RDSインスタンスに付ける名前。
  identifier = "main"

  max_allocated_storage = 0

  # インスタンスクラスを設定する。
  instance_class = "db.t3.micro"

  # モニタリングの間隔。
  monitoring_interval = 60

  # モニタリングを行うためのIAMロール設定。(※ 詳細は後述)
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  # マルチAZ配置の利用有無。
  #  - スタンバイ用インスタンスも建てたいのえ、有効。
  multi_az = true

  # オプショングループ設定。
  #  - aws_db_option_group を使用する。
  option_group_name = aws_db_option_group.main.name

  # パラメータグループ設定。
  #  - aws_db_parameter_group を使用する。
  parameter_group_name = aws_db_parameter_group.main.name

  # DBユーザーとパスワード設定。
  #  - セキュリティの観点から、パスワードはインスタンス構築後に手動で変更する予定。
  username = "root"
  password = var.password

  # DBへの接続を許可するポート。
  port = 3306

  # インターネットからのアクセスを許可するかどうかの設定。
  #  - インターネットからのアクセスは許可しないため無効。
  publicly_accessible = true

  # レプリカの元になるDBを指定する設定。
  #  - レプリカではないため無効。
  # replicate_source_db  = aws_db_instance.db.identifier

  # ストレージの暗号化有無。
  #  - セキュリティの観点から暗号化したいため有効。
  storage_encrypted = true

  # ストレージの暗号化に使用するKMSのキー設定。
  #  - aws_kms_key を使用する。
  kms_key_id = aws_kms_key.rds_storage.arn

  # セキュリティグループ設定。
  #  - 今回は別でDB用のセキュリティグループを作成していたので、それを使用。解説は省略。
  vpc_security_group_ids = [
    # var.security_group_db
    aws_security_group.free_security_db.id
  ]

  # パフォーマンスインサイト設定。
  #  - 今回使用する db.t3.micro では対応していないため無効。
  performance_insights_enabled = false
  # performance_insights_kms_key_id       = aws_kms_key.rds_performance_insight.arn
  # performance_insights_retention_period = 7

  # ライフサイクル設定。
  lifecycle {
    # passwordの変更はTerraformとして無視する。セキュリティの観点からインスタンス構築後、手動でパスワードを変更するため。
    ignore_changes = [password]
  }

  tags = {
    Env = "dev"
  }
}

