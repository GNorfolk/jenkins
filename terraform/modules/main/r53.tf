resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "jenkins.norfolkgaming.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.jenkins.public_ip]
}