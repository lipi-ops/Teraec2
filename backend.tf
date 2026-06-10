terraform {
  backend "s3" {
    bucket         = "terrafrm-lipi-test1"
    key            = "mydoc1/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
