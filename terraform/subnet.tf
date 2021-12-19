
resource "aws_subnet" "twitter_db_subnet_1a" {
  vpc_id = var.vpc_id
  #   availability_zone = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.3.0/24"

  tags = {
    Name = "twitter_db_subnet_1a_default"
  }
}

resource "aws_subnet" "twitter_db_subnet_1c" {
  vpc_id = var.vpc_id
  #   availability_zone = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.4.0/24"

  tags = {
    Name = "twitter_db_subnet_1c_default"
  }
}



# route table -------------------
# -------------------------------
data "aws_internet_gateway" "discord_internet_gateway" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_route_table" "twitter_debug_subnet_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "twitter_debug_subnet_rt-public"
  }
}

# Route
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "public_debug_twitter_db" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.twitter_debug_subnet_rt.id
  gateway_id             = data.aws_internet_gateway.discord_internet_gateway.id
}

# Association
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public_debug_twitter_db_1a" {

  subnet_id      = aws_subnet.twitter_db_subnet_1a.id
  route_table_id = aws_route_table.twitter_debug_subnet_rt.id
}
resource "aws_route_table_association" "public_debug_twitter_db_1c" {

  subnet_id      = aws_subnet.twitter_db_subnet_1c.id
  route_table_id = aws_route_table.twitter_debug_subnet_rt.id
}
