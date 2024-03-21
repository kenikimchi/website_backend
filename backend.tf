terraform {
  backend "s3" {
    bucket         = "kendrickkim-tfstate"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "tf-statelock"
    encrypt        = true
  }
}