data "aws_ami" "jenkins" {
  most_recent = true
  filter {
    name   = "name"
    values = ["jenkins*"]
  }
}

data "aws_route53_zone" "main" {
  name = "norfolkgaming.com"
}