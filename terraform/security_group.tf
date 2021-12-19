resource "aws_security_group" "free_security_db" {
  name   = "no_security"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "all_free_security" {
  name   = "all_free_security"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# resource "aws_security_group" "free_security_db" {
#   name   = "no_security"
#   vpc_id = var.vpc_id

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"

#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "internal_security_db" {
#   name   = "セキュリティなし"
#   vpc_id = var.vpc_id

#   ingress {
#     from_port = 3306
#     to_port   = 3306
#     protocol  = "tcp"

#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   egress {
#     from_port = 3306
#     to_port   = 3306
#     protocol  = "tcp"
#     cidr_blocks = ["10.0.0.0/16"] 
#   }
# }

