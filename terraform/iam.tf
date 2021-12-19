############################################
# IAM
############################################
# IAMロールの信頼ポリシーを作成する。
#  - 「monitoring.rds.amazonaws.com」がAssumeRoleすることを許可するポリシーを作成。
data "aws_iam_policy_document" "rds_monitoring_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# IAMロールを作成する。
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds_monitoring_role"

  # 上で作成した信頼ポリシーをロールにアタッチする。
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_policy.json
}

# RDS拡張モニタリングを実行するためのAWS管理ポリシーをIAMロールにアタッチする。
resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.rds_monitoring_role.name
}