# Basic Example: SCA-Only Deployment

This example demonstrates how to onboard an AWS account to CCE with only **SCA (Secure Cloud Access)** enabled.

## What This Example Creates

- IAM role for SCA with cross-account trust
- IAM policy with permissions for cloud entitlements management
- CCE account registration

## Prerequisites

1. **Terraform** >= 1.8.5
2. **AWS credentials** configured (via AWS CLI, environment variables, or IAM role)
3. **CyberArk tenant credentials** for the idsec provider

## Usage

### Step 1: Configure CyberArk Provider

Set the following environment variables with your CyberArk tenant credentials:

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
aws_region           = "us-east-1"
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
sca_role_arn = "arn:aws:iam::123456789012:role/SCARole-123456789012-d43ac004-6cc1-4ad1-bae2-89ad57f03e3d"
```

## What Gets Created in AWS

### IAM Resources

1. **IAM Role**: `SCARole-{account-id}-{tenant-id}`
   - Trust relationship with SCA service account
   - External ID validation for security

2. **IAM Policy**: `SCAPolicy-{account-id}-{tenant-id}`
   - Permissions for IAM role management
   - SAML provider management
   - Role assumption capabilities

3. **IAM Permissions Policy**: `SCAPermissionsPolicy-{account-id}-{tenant-id}`
   - IAM account permissions for SCA operations

## Cleanup

To remove all resources created by this example:

```bash
terraform destroy
```

## Next Steps

- See the [complete example](../complete/) for enabling multiple services
- Review the [main module documentation](../../README.md) for all configuration options


