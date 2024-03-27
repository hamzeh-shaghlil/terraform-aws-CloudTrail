# CloudTrail

AWS CloudTrail is an AWS service that helps you enable operational and risk auditing, governance, and compliance of your AWS account. Actions taken by a user, role, or an AWS service are recorded as events in CloudTrail. Events include actions taken in the AWS Management Console, AWS Command Line Interface, and AWS SDKs and APIs.

<img width="1376" alt="Screenshot 2024-03-27 at 4 42 55 PM" src="https://github.com/hamzeh-shaghlil/terraform-aws-CloudTrail/assets/15934776/ad28c02e-abd2-4558-9e6c-76e50abaab1f">


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

### Attributes

`account_name` : (*required*) used to name the S3 bucket and the trail name.

`region` : (*required*) the region which the resources will be created in.

`email` : (*required*) the email that will recieve the SNS alarms.
