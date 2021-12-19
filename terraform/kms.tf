############################################
# KMS
############################################
resource "aws_kms_key" "rds_storage" {
  description = "key to encrypt rds storage."

  # CMKの使用方法を設定する。データの暗号化/復号化(ENCRYPT_DECRYPT)、メッセージの署名および署名の検証(SIGN_VERIFY)が設定できる。
  #  - データの暗号化を行うため、「ENCRYPT_DECRYPT」を設定する。
  key_usage = "ENCRYPT_DECRYPT"

  # リソースが削除されてからキーを完全に削除するまでの期間(日)。7〜30を指定することができる。
  deletion_window_in_days = 7

  # マスターキーをローテーションするかどうかの設定。
  # (動作)
  # ローテーション後は、新規のデータはローテーション後のキーで暗号化/復号化される。ローテーション以前に暗号化したデータは、ローテーション前の古いキーで復号化する。
  enable_key_rotation = true

  tags = {
    Env = "dev"
  }
}
