terraform {
  backend "s3" {
    bucket = "norfolkgaming-tfstate"
    key = "jenkins.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
