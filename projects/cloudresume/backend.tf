terraform {
  backend "s3" {
    bucket         = "kendrickkim-tfstate"
    key            = "cloudresume/cloudresume-state.tfstate"
    region         = "us-west-1"
    dynamodb_table = "tf-statelock"
    encrypt        = true
  }
}