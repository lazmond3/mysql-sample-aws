resource "aws_key_pair" "mmm3" {
  key_name   = "mmm3"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVzrEB9jq/2jJSbKw+wv3fmP4vRurlAqnc827x3PDE6Nkdkyl++7JGBsG58QI/RAQjN/Z54Zy8l80LNbo3IJoNZAZ+0nALFdzJfORLWx3je69MQ5X6kLRh36PcBNkbxk+/QYaR3LOGOhwMN+GtK/6WNowNxTrg44KPV8wJicu/glqF9xJQn5+1Y4np+orr+TQr6GHlZDhQy7yeVd4XuEK1PAw+60tA53TAEktRB/RuiFb0/FmT7DsHg94txMD3Zvba0xl0SFSbVwdyDHRJrrDTykPnDkNdYj0KwmI2fTklNA1jvCjIFdiTGJBVfBCZDxB/1d/BbH1IbptWNnLl1ToX mmm2-name"
}

resource "aws_instance" "rds_debug_ec2_1" {
  ami           = "ami-011facbea5ec0363b"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mmm3.key_name
  vpc_security_group_ids = [
    aws_security_group.all_free_security.id
  ]
  subnet_id                   = aws_subnet.twitter_db_subnet_1c.id
  associate_public_ip_address = "true"
  # ebs_block_device {
  #   device_name = "/dev/xvda"
  #   volume_type = "gp2"
  #   volume_size = 30
  # }
  # user_data          = "${file("./userdata/cloud-init.tpl")}"
  tags = {
    Name = "rds_debug_ec2_1"
  }
}



resource "aws_eip" "debug_ec2" {
  vpc = true
  tags = {
    Name = "debug_ec2"
  }
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.rds_debug_ec2_1.id
  allocation_id = aws_eip.debug_ec2.id
}
