data "aws_ami" "jenkins" {
  most_recent = true
  owners = [103348857345]
  filter {
    name = "tag:Name"
    values = ["jenkins*"]
  }
}

data "aws_route53_zone" "main" {
  name = "norfolkgaming.com"
}