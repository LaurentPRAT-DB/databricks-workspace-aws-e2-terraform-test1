// Create the required AWS STS assume role policy in your AWS account.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_assume_role_policy
data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

// Create the required IAM role in your AWS account.
// See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "cross_account_role" {
  name               = "${local.prefix}-crossaccount"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = var.tags
}

// Create the required AWS cross-account policy in your AWS account.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_crossaccount_policy
data "databricks_aws_crossaccount_policy" "this" {}

// Create the required IAM role inline policy in your AWS account.
// See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "this" {
  name   = "${local.prefix}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}

// Properly configure the cross-account role for the creation of new workspaces within your AWS account.
// See https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_credentials
resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = "${local.prefix}-creds"
  depends_on       = [ time_sleep.wait]
  //depends_on       = [aws_iam_role_policy.this]
}

/* 

Error: cannot create mws credentials: MALFORMED_REQUEST: Failed credential validation checks: please use a valid cross account IAM role with permissions setup correctly
│ 
│   with databricks_mws_credentials.this,
│   on cross-account-role.tf line 29, in resource "databricks_mws_credentials" "this":
│   29: resource "databricks_mws_credentials" "this" {

fix: https://kb.databricks.com/en_US/terraform/failed-credential-validation-checks-error-with-terraform

*/
resource "time_sleep" "wait" {
  depends_on = [
    aws_iam_role.cross_account_role
  ]
  create_duration = "10s"
}