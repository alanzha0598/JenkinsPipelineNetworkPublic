##################################################################################
# BACKENDS
##################################################################################
terraform {
  backend "s3" {
    profile = "marymoe"
    bucket = "ddt-networking-3456"
    dynamodb_table = "ddt-tfstatelock"
    key = "networking.state"
    region = "us-west-2"
  }
}
