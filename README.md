# CCE AWS Account Onboarding Module

This Terraform module onboards AWS member accounts to Connect Cloud Environments (CCE) with CyberArk SaaS services.
CCE helps customers easily adopt CyberArk services and establish secure trust relationships with their AWS environments.

## Overview

This module automates the creation of the required AWS IAM resources and establishes trust relationships with services, enabling seamless integration in a single deployment.

The module supports multiple services that can be enabled independently or together:
- **SIA (Secure Infrastructure Access)** - Provides just-in-time privileged access to EC2 instances
- **SCA (Secure Cloud Access)** - Enables secure cloud entitlements management

## Features

- **Automated IAM Setup**: Creates and configures IAM roles and policies
- **Multi-Service Support**: Enable SIA and/or SCA based on your needs
- **Security Best Practices**: Implements least-privilege access with external ID validation
- **Idempotent**: Safe to run multiple times
- **Production Ready**: Includes validation, error handling, and comprehensive outputs

## Architecture

This module creates the following resources in your AWS account:

### For SIA (Secure Infrastructure Access)
- IAM role: `CyberArkSIA-{unique-suffix}`
- IAM policy: `CyberarkJitAccountProvisioningPolicy-{tenant-id}-{unique-suffix}`
- Permissions: EC2 instance and region discovery

### For SCA (Secure Cloud Access)
- IAM role: `CyberArkRoleSCA-{account-id}`
- IAM policy: `CyberArkPolicyAccountForSCA-{account-id}`
- Permissions: IAM role management, SAML provider management

## Prerequisites

Before using this module, ensure that you have the following information and requirements:

1. **Identity Security Platform Account**
   - API credentials (client ID and secret)
   - Tenant URL

2. **AWS Requirements**
   - AWS credentials configured with the appropriate permissions
   - Permissions to create IAM roles and policies
   - AWS account ID that you want to onboard

3. **Terraform Requirements**
   - Terraform >= 1.8.5
   - AWS Provider ~> 5.0
   - CyberArk idsec Provider ~> 1.0

## Usage

### Basic Example - SCA Only

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    idsec = {
      source  = "cyberark/idsec"
      version = "~> 0.2.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "idsec" {
  # Configure with your CyberArk tenant credentials
  # See: https://registry.terraform.io/providers/cyberark/idsec/latest/docs
}

module "cce_onboarding" {
  source = "path/to/terraform-aws-cce-account"
   
  account_id           = "123456789012"
  account_display_name = "Production AWS account"
   
  # Enable only SCA
  sca = {
    enable     = true
  }
}
```

### Complete Example - SIA and SCA

```hcl
module "cce_onboarding" {
  source = "path/to/terraform-aws-cce-account"

  account_id           = "123456789012"
  account_display_name = "Production AWS account"

  # Enable SIA
  sia = {
    enable = true
  }

  sca = {
    enable = true
  }
}
```

## Service Configuration

### SIA (Secure Infrastructure Access)

SIA provides just-in-time privileged access to your EC2 instances. To enable:

```hcl
sia = {
  enable = true
}
```

**Note**: Internally, SIA uses the name "dpa" (Dynamic Privileged Access) for backward compatibility with existing deployments.

### SCA (Secure Cloud Access)

SCA enables secure cloud entitlements management. Configuration options:

```hcl
# Basic SCA
sca = {
  enable     = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account_id | The AWS account ID that you want to onboard. Must be a valid 12-digit AWS account ID. | `string` | n/a | yes |
| account_display_name | The display name for the AWS account | `string` | `"AWS Account"` | no |
| sia | Configuration for SIA (Secure Infrastructure Access). Note: Uses DPA internally for backward compatibility. | `object({ enable = optional(bool, true) })` | `null` | no |
| sca | Configuration for SCA (Secure Cloud Access).

## Outputs

| Name | Description |
|------|-------------|
| account_id | The AWS account ID that was onboarded |
| account_display_name | The display name of the AWS account |
| deployment_region | The AWS region where resources were deployed |
| sia_role_arn | The IAM role ARN created for SIA. Returns null if SIA is not enabled. |
| sca_role_arn | The IAM role ARN created for SCA. Returns null if SCA is not enabled. |
| enabled_services | List of services that were enabled for this account |

## Examples

See the [examples](./examples) directory for complete, working examples:

- **[basic](./examples/basic/)** - Basic SCA-only deployment
- **[complete](./examples/complete/)** - SIA and SCA enabled

## IAM Required Permissions

The AWS credentials used to run this module require the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:GetPolicy",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:TagRole",
        "iam:UntagRole"
      ],
      "Resource": "*"
    }
  ]
}
```

## Security Considerations

- **External ID Validation**: All cross-account role assumptions use external ID validation to prevent confused deputy attacks
- **Least Privilege**: IAM policies grant only the minimum permissions required for each service
- **Trust Policies**: Roles can only be assumed by verified service accounts with proper conditions
- **Regional Deployment**: Resources are deployed in the region specified by your AWS provider configuration

## Troubleshooting

### Issue: "The account_id must be a valid 12-digit AWS account ID"
**Solution**: Ensure your `account_id` variable contains exactly 12 digits without any spaces or special characters.

### Issue: Provider authentication errors
**Solution**: Ensure your `idsec` provider is correctly configured with valid CyberArk credentials. See [provider documentation](https://registry.terraform.io/providers/cyberark/idsec/latest/docs) for more information.

## Versioning

This module follows [Semantic Versioning](https://semver.org/). Current version: **0.1.0**

## Licensing

This repository is subject to the following licenses:
- **CyberArk Privileged Access Manager**: Licensed under the [CyberArk Software EULA](https://www.cyberark.com/EULA.pdf)
- **Terraform templates**: Licensed under the Apache License, Version 2.0 ([LICENSE](LICENSE))

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for more details.

## Support

For issues related to this Terraform module, please open an issue in this repository.

For CCE platform support, please contact CyberArk support.

## About CyberArk

CyberArk is a global leader in **Identity Security**, providing powerful solutions for managing privileged access and securing cloud environments. Learn more at [www.cyberark.com](https://www.cyberark.com).