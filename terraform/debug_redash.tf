# resource "aws_key_pair" "mmm3" {
#   key_name   = "mmm3"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVzrEB9jq/2jJSbKw+wv3fmP4vRurlAqnc827x3PDE6Nkdkyl++7JGBsG58QI/RAQjN/Z54Zy8l80LNbo3IJoNZAZ+0nALFdzJfORLWx3je69MQ5X6kLRh36PcBNkbxk+/QYaR3LOGOhwMN+GtK/6WNowNxTrg44KPV8wJicu/glqF9xJQn5+1Y4np+orr+TQr6GHlZDhQy7yeVd4XuEK1PAw+60tA53TAEktRB/RuiFb0/FmT7DsHg94txMD3Zvba0xl0SFSbVwdyDHRJrrDTykPnDkNdYj0KwmI2fTklNA1jvCjIFdiTGJBVfBCZDxB/1d/BbH1IbptWNnLl1ToX mmm2-name"
#   #   public_key = file("./p_rsa.pub")
# }

# resource "aws_subnet" "rds_debug_ec2_1" {
#   vpc_id = var.vpc_id
#   #   availability_zone = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
#   availability_zone = "ap-northeast-1c"
#   cidr_block        = "10.0.5.0/24"

#   tags = {
#     Name = "rds_debug_ec2_1"
#   }
# }

resource "aws_instance" "rds_redash" {
  ami           = "ami-060741a96307668be"
  instance_type = "t2.small"
  key_name      = aws_key_pair.mmm3.key_name
  vpc_security_group_ids = [
    aws_security_group.all_free_security.id
  ]
  subnet_id                   = aws_subnet.twitter_db_subnet_1c.id
  associate_public_ip_address = "true"
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 30
  }
  # user_data          = "${file("./userdata/cloud-init.tpl")}"
  tags = {
    Name = "redash"
  }
}



resource "aws_eip" "redash_eip" {
  vpc = true
  tags = {
    Name = "debug_ec2"
  }
}
resource "aws_eip_association" "eip_assoc_redash" {
  instance_id   = aws_instance.rds_redash.id
  allocation_id = aws_eip.redash_eip.id
}
