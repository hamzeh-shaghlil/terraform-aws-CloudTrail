variable "account_name" {
  type        = string
  description = "Account name to use when creating the s3 bucket"
}

variable "region" {
  type        = string
  description = "Region to create the recources in"
}


variable "email" {
  type        = string
  description = "Email to receive SNS notification"
}
