terraform {
  backend "s3" {
    bucket = "terminolabs"
    key = "lup-dev-env/state/dev-env.state"
    region = "ap-south-1"
    dynamodb_table = "s3-state-lock"
  }
}