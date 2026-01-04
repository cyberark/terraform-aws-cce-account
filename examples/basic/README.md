# Basic Example: SCA-Only Deployment

This example demonstrates how to onboard an AWS account to CyberArk CCE with only the **SCA (Secure Cloud Access)** service enabled.

## What This Example Creates

- IAM Role for SCA service with cross-account trust
- IAM Policy with permissions for cloud entitlements management
- CyberArk CCE account registration

## Prerequisites

1. **Terraform** >= 1.8.5
2. **AWS credentials** configured (via AWS CLI, environment variables, or IAM role)
3. **CyberArk CCE tenant credentials** for the idsec provider

## Usage

### Step 1: Configure CyberArk CCE Provider

Set the following environment variables with your CyberArk CCE tenant credentials:

```bash
export IDSEC_TENANT_URL="https://your-tenant.cyberark.cloud"
export IDSEC_CLIENT_ID="your-client-id"
export IDSEC_CLIENT_SECRET="your-client-secret"
```

### Step 2: Create terraform.tfvars

Create a `terraform.tfvars` file with your AWS account details:

```hcl
account_id           = "123456789012"
account_display_name = "My Production AWS Account"
aws_region          = "us-east-1"
```

### Step 3: Initialize and Apply

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

## Example Output

After successful deployment, you'll see outputs similar to:

```
Outputs:

account_id = "123456789012"
deployment_region = "us-east-1"
enabled_services = ["sca"]
sca_role_arn = "arn:aws:iam::123456789012:role/CyberArkRoleSCATerraform-123456789012"
```

## What Gets Created in AWS

### IAM Resources

1. **IAM Role**: `CyberArkRoleSCATerraform-{account-id}`
   - Trust relationship with CyberArk SCA service account
   - External ID validation for security

2. **IAM Policy**: `CyberArkPolicyAccountForSCATerraform-{account-id}`
   - Permissions for IAM role management
   - SAML provider management
   - Role assumption capabilities

## Cleanup

To remove all resources created by this example:

```bash
terraform destroy
```

## Next Steps

- See the [complete example](../complete/) for enabling multiple services
- Review the [main module documentation](../../README.md) for all configuration options
- Configure SSO integration by setting `sso_enable = true` (requires `sso_region`)

## Notes

- This example does **not** enable AWS IAM Identity Center (SSO) integration
- To enable SSO, modify the `sca` block in `main.tf`:
  ```hcl
  sca = {
    enable     = true
    sso_enable = true
    sso_region = "us-east-1"
  }
  ```

