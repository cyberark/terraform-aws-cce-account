# Example: Complete Multi-Service Deployment

This example demonstrates how to onboard an AWS account to CyberArk CCE with **all services enabled**:
- **SIA (Secure Infrastructure Access)** - For privileged access to infrastructure resources
- **SCA (Secure Cloud Access)** - With AWS IAM Identity Center (SSO) integration

## What This Example Creates

### SIA Service
- IAM Role for SIA service with cross-account trust to CyberArk DPA service
- IAM Policy with EC2 discovery permissions

### SCA Service
- IAM Role for SCA service with cross-account trust
- IAM Policy for cloud entitlements management
- IAM Policy for SSO/Identity Center integration (when enabled)

### CyberArk CCE
- Account registration with both services enabled

## Prerequisites

1. **Terraform** >= 1.8.5
2. **AWS credentials** configured with permissions to create IAM resources
3. **CyberArk CCE tenant credentials** for the idsec provider
4. **(Optional)** AWS IAM Identity Center enabled in your account if using SSO

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
enable_sso          = true
sso_region          = "us-east-1"
```

**Note**: If you don't want to enable SSO integration, set `enable_sso = false`.

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
sca_sso_enabled = true
sia_role_arn = "arn:aws:iam::123456789012:role/CyberArkDynamicPrivilegedAccess-abc12345"
```

## What Gets Created in AWS

### SIA Resources

1. **IAM Role**: `CyberArkDynamicPrivilegedAccess-{tenant-id}`
   - Trust relationship with CyberArk DPA service account
   - External ID validation using tenant ID

2. **IAM Policy**: `CyberarkJitAccountProvisioningPolicy-{tenant-id}`
   - Permissions: `ec2:DescribeInstances`, `ec2:DescribeRegions`

### SCA Resources

1. **IAM Role**: `CyberArkRoleSCATerraform-{account-id}`
   - Trust relationship with CyberArk SCA service account
   - External ID validation

2. **IAM Policy**: `CyberArkPolicyAccountForSCATerraform-{account-id}`
   - IAM role and SAML provider management
   - Session tagging and role assumption

3. **IAM Policy** (if SSO enabled): `CyberArkPolicySSOForSCATerraform-{account-id}`
   - SSO/Identity Center permissions
   - Identity store access
   - Permission set management

## Configuration Options

### Disable SSO Integration

If you don't need AWS IAM Identity Center integration, modify your `terraform.tfvars`:

```hcl
enable_sso = false
```

### Enable Only Specific Services

To enable only SIA or SCA, see the [basic example](../example_1/) or modify the module call in `main.tf`:

```hcl
# SIA only
module "cce_onboarding" {
  source = "../.."
  
  account_id = var.account_id
  sia = { enable = true }
  sca = null
}

# SCA only
module "cce_onboarding" {
  source = "../.."
  
  account_id = var.account_id
  sia = null
  sca = { enable = true, sso_enable = false }
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
- (If SSO enabled) Access Identity Center resources

See the [main module documentation](../../README.md#iam-permissions-required) for the complete IAM policy.

## Troubleshooting

### SSO Region Issues

If you see errors related to SSO, ensure:
1. AWS IAM Identity Center is enabled in your account
2. The `sso_region` matches where Identity Center is configured
3. Your AWS credentials have permissions to access Identity Center

### External ID Validation Errors

The module uses external ID validation for security. These are automatically managed by the CyberArk CCE platform and should not require manual configuration.

## Next Steps

- Review the [main module documentation](../../README.md) for detailed information
- Learn about [SIA service configuration](../../README.md#sia-secure-instance-access)
- Learn about [SCA service configuration](../../README.md#sca-secure-cloud-access)
- Explore CyberArk CCE platform features in your tenant portal

## Notes

- **Service Naming**: The SIA service uses "dpa" internally for backward compatibility with existing deployments
- **Regional Resources**: All IAM resources are global, but the deployment is registered in the specified region
- **Idempotent**: Safe to run multiple times; Terraform will only create resources that don't exist

