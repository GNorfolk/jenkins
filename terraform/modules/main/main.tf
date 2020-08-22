resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = {
    Name = "jenkins"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.cidr, 4, each.value)
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"
  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

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

resource "aws_instance" "web" {
  ami           = "ami-07d9160fa81ccffb5"
  instance_type = "t3.micro"
}
