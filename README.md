# Automate Enabling CloudTrail for API Log Auditing with SNS and Utilizing CloudWatch Alarms using Terraform


**CloudTrail**
AWS CloudTrail is an AWS service that helps you enable operational and risk auditing, governance, and compliance of your AWS account. Actions taken by a user, role, or an AWS service are recorded as events in CloudTrail. Events include actions taken in the AWS Management Console, AWS Command Line Interface, and AWS SDKs and APIs.

<img width="1376" alt="Screenshot 2024-03-27 at 4 42 55 PM" src="https://github.com/hamzeh-shaghlil/terraform-aws-CloudTrail/assets/15934776/ad28c02e-abd2-4558-9e6c-76e50abaab1f">

**AWS KMS**
AWS Key Management Service (AWS KMS) is a managed service that makes it easy for you to create and control the cryptographic keys that are used to protect your data

**AWS SNS**
Amazon Simple Notification Service (Amazon SNS) is a managed service that provides message delivery from publishers to subscribers (also known as producers and consumers). 

**AWS CloudWatch**
Amazon CloudWatch monitors your Amazon Web Services (AWS) resources and the applications you run on AWS in real time. You can use CloudWatch to collect and track metrics, which are variables you can measure for your resources and applications.

CloudTrail is active in your AWS account when you create it and doesn't require any manual setup. When activity occurs in your AWS account, that activity is recorded in a CloudTrail event
## Overview

This module creates an S3 Bucket and the required resources to enable CloudTrail.

The following resources will be created:

1. S3 Bucket with policy.
2. CloudWatch Log Group.
3. IAM Role fow sending CloudTrail logs to CloudWatch.
4. KMS for log encryption.
5. CloudTrail.
6. CloudWatch security alarms.


## Usage

```
module "cloudtrail" {
    source = "./Modules/CloudTrail"
    account_name = "accountname"
    region = "eu-west-1"
    email = "email-address"
}
```
This terraform use S3 as backend for terraform state 
  1. Update the `backend.tf`  
```terraform
terraform {
  backend "s3" {
    encrypt = true
    bucket  = "your-backet-name"
    key     = "terraform.tfstate"
    region  = "your-bucket-region"
  }
}
```

2. Update the AWS Account ID in `buildspec.yaml` file

3. Run the terraform init command to initialize a working directory that contains a Terraform configuration
```
terraform init
```
4. The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace
```
terraform plan
```
5. The terraform apply command performs a plan just like terraform plan does, but then actually carries out the planned changes to each resource using the relevant infrastructure provider's API. It asks for confirmation from the user before making any changes, unless it was explicitly told to skip approval.
```
terraform apply
```
6. After finishing, you will have the below results
```
Apply complete!  

terraform output
````




### Attributes

`account_name` : (*required*) used to name the S3 bucket and the trail name.

`region` : (*required*) the region which the resources will be created in.

`email` : (*required*) the email that will recieve the SNS alarms.


## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.cloudtrail_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.cloudtrail_cloudwatch_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_alias.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudtrail_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_kms_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

