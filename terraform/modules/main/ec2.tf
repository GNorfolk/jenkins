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

resource "aws_security_group" "jenkins" {
  name          = "jenkins"
  vpc_id        = aws_vpc.main.id
  ingress {
    from_port       = 8080
    to_port         = 8080
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
    Name = "jenkins"
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.jenkins.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main.id
  iam_instance_profile = aws_iam_role.jenkins.name
  tags = {
    Name = "jenkins"
  }
}