resource "aws_security_group" "packer" {
  name          = "packer-jenkins"
  vpc_id        = aws_vpc.main.id
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "packer-jenkins"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-07d9160fa81ccffb5"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main.id
}
