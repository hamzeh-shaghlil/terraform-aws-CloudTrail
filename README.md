# CloudTrail

## Overview

This module creates an S3 Bucket and the required resources to enable CloudTrail.

The following resources will be created:

1. S3 Bucket with policy.
2. CloudWatch Log Group.
3. IAM Role fow sending CloudTrail logs to CloudWatch.
4. KMS for log encryption.
5. CloudTrail.
6. CloudWatch security alarams.


## Usage

```
module "cloudtrail" {
    source = "./Modules/CloudTrail"
    account_name = "hisham"
    region = "eu-west-1"
    email = "email-address"
}
```

### Attributes

`account_name` : (*required*) used to name the S3 bucket and the trail name.

`region` : (*required*) the region which the resources will be created in.

`email` : (*required*) the email that will recieve the SNS alarms.
