variable "aws_region" {
  description = "The AWS region to create resources in."
  default = "eu-west-1"
}

variable "aws_amis" {
  default = {
    us-east-1 =  "ami-2f73014a"
  }
}
