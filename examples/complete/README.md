# Example: Complete Multi-Service Deployment

This example demonstrates how to onboard an AWS account to CCE with **all services enabled**:
- **SIA (Secure Infrastructure Access)** - For privileged access to EC2 instances
- **SCA (Secure Cloud Access)** - For secure cloud entitlements management

## What This Example Creates

### SIA
- IAM Role for SIA with cross-account trust to DPA
- IAM Policy with EC2 discovery permissions

### SCA
- IAM role for SCA with cross-account trust
- IAM policies for cloud entitlements and IAM account permissions

### CCE
- Account registration with both services enabled

## Prerequisites

1. **Terraform** >= 1.8.5
2. **AWS credentials** configured with permissions to create IAM resources
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
account_display_name = "My Production AWS Account - Complete"
deployment_region = "us-east-1"
enabled_services = ["sia", "sca"]
sca_role_arn = "arn:aws:iam::123456789012:role/CyberArkRoleSCATerraform-123456789012"
sia_role_arn = "arn:aws:iam::123456789012:role/CyberArkDynamicPrivilegedAccess-abc12345"
```

## What Gets Created in AWS

### SIA Resources

1. **IAM role**: `CyberArkDynamicPrivilegedAccess-{tenant-id}`
   - Trust relationship with DPA account
   - External ID validation using tenant ID

2. **IAM policy**: `CyberarkJitAccountProvisioningPolicy-{tenant-id}`
   - Permissions: `ec2:DescribeInstances`, `ec2:DescribeRegions`

### SCA Resources

1. **IAM role**: `CyberArkRoleSCATerraform-{account-id}`
   - Trust relationship with SCA service account
   - External ID validation

2. **IAM policies**: managed policies attached for SCA cross-account and IAM account permissions

## Configuration Options

### Enable Only Specific Services

To enable only SIA or SCA, see the [basic example](../example_1/) or modify the module call in `main.tf`:

```hcl
# SIA only
module "cce_onboarding" {
  source = "../.."

  account_id = var.account_id
  sia        = { enable = true }
  sca        = null
}

# SCA only
module "cce_onboarding" {
  source = "../.."
  
  account_id = var.account_id
  sia        = null
  sca        = { enable = true }
}
```

## Cleanup

To remove all resources created by this example:

```bash
terraform destroy
```

## IAM Permissions Required

The AWS credentials used to run this example need permissions to:
- Create and manage IAM roles
- Create and manage IAM policies
- Attach/detach policies to/from roles

See the [main module documentation](../../README.md#iam-permissions-required) for the complete IAM policy.

## Troubleshooting

### External ID Validation Errors

This module uses external ID validation for security. This is automatically managed by CCE and should not require manual configuration.

## Next Steps

- Review the [main module documentation](../../README.md) for detailed information
- Learn about [SIA configuration](../../README.md#sia-secure-instance-access)
- Learn about [SCA configuration](../../README.md#sca-secure-cloud-access)
- Explore CCE features in your tenant portal

## Notes

- **Service Naming**: SIA uses "dpa" internally for backward compatibility with existing deployments
- **Regional Resources**: All IAM resources are global, but the deployment is registered in the specified region
- **Idempotent**: Safe to run multiple times; Terraform will only create resources that don't exist
