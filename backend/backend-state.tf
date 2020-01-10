terraform {
  backend "s3" {
#    bucket         = "${var.PROJECT-NAME}-terraform"
    bucket         = "meu-terraform"
    key            = "develop-tfstate/develop.tfstate"
#    key            = "${var.PROJECT-NAME}-terraform/${var.enviroment}-tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "meu-develop-terraformstate"

  }
}