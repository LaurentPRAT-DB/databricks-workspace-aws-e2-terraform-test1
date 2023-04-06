# databricks-workspace-aws-e2-terraform-test1

## Requirements
An existing or new Databricks on AWS account. To create a new Databricks Platform Free Trial account, follow the instructions in Get started: Free trial & setup.

Note

For a new Databricks account, you must set up an initial workspace, which the preceding instructions guide you through. This tutorial enables you to use the Databricks Terraform provider to create an additional workspace beyond the initial one.

Your Databricks account username and password.

Your Databricks account ID. To get this value, follow Locate your account ID.

For the AWS account associated with your Databricks account, permissions for your AWS Identity and Access Management (IAM) user in the AWS account to create:

### An IAM cross-account policy and role.

A virtual private cloud (VPC) and associated resources in Amazon VPC.

### An Amazon S3 bucket.

See Changing permissions for an IAM user on the AWS website.

For your IAM user in the AWS account, an AWS access key, which consists of an AWS secret key and an AWS secret access key. See Managing access keys (console) on the AWS website.

A development machine with the Terraform CLI and Git installed. See Download Terraform on the Terraform website and Install Git on the GitHub website.

An existing or new GitHub account. To create one, see Signing up for a new GitHub account on the GitHub website.
