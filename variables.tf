##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

variable "cidr" {}

variable "azs" {
  type = list (string)
}

variable "private_subnets" {
  type = list (string)
}

variable "public_subnets" {
  type = list (string)
}



