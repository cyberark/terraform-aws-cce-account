terraform {
  required_version = ">= 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "random_uuid" "suffix" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  sca_cross_account_iam_role_name = (
    var.custom_role_name != null && var.custom_role_name != ""
    ? "${var.custom_role_name}-${local.account_id}"
    : "CyberArkRoleSCA${local.account_id}-${var.tenant_id}"
  )
  sca_cross_account_managed_policy_name = (
    var.custom_role_name != null && var.custom_role_name != ""
    ? "${var.custom_role_name}${local.account_id}ForSCAPolicy"
    : "CyberArkPolicyAccountForSCA${local.account_id}-${var.tenant_id}"
  )
  sca_account_permissions_managed_policy_name = (
    var.custom_role_name != null && var.custom_role_name != ""
    ? "${var.custom_role_name}${local.account_id}ForSCAIAMPolicy"
    : "CyberarkIAMAccountPermissionsPolicyForSCA${local.account_id}-${var.tenant_id}"
  )
}

########
# DATA #
########

data "aws_iam_policy_document" "cyberark_sca_cross_account_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.sca_service_account_id}:root"]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "sts:ExternalId"
      values   = ["${var.tenant_id}-${local.account_id}"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::${var.sca_service_account_id}:role/sca-provision-role*"
      ]
    }
  }
}


data "aws_iam_policy_document" "cyberark_sca_cross_account_policy_document" {
  statement {
    sid       = "scapolicyallowtag"
    effect    = "Allow"
    actions   = ["sts:TagSession"]
    resources = ["*"]
  }

  statement {
    sid    = "AssumeCustomerRole"
    effect = "Allow"
    actions = ["sts:AssumeRole",
    "sts:SetSourceIdentity"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cyberark_account_permissions_policy_document" {
  statement {
    sid    = "scapolicyaccountpermissions"
    effect = "Allow"
    actions = ["iam:UpdateAssumeRolePolicy",
      "iam:ListSAMLProviders",
      "iam:DeleteRolePolicy",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:GetSAMLProvider",
      "iam:GetRole",
      "iam:ListRoles",
      "iam:ListAttachedRolePolicies",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListRolePolicies",
    "iam:CreateSAMLProvider"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "cyberark_sca_cross_account_assume_role" {
  name               = local.sca_cross_account_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.cyberark_sca_cross_account_assume_role_policy.json
  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_iam_policy" "cyberark_sca_cross_account_policy" {
  name        = local.sca_cross_account_managed_policy_name
  description = "The policy contains sca cross account permissions"
  policy      = data.aws_iam_policy_document.cyberark_sca_cross_account_policy_document.json
}

resource "aws_iam_policy" "cyberark_account_permissions_policy" {
  name        = local.sca_account_permissions_managed_policy_name
  description = "The policy contains sca IAM account permissions"
  policy      = data.aws_iam_policy_document.cyberark_account_permissions_policy_document.json
}

resource "aws_iam_role_policy_attachment" "cyberark_sca_cross_account_role_attached_to_policy" {
  role       = aws_iam_role.cyberark_sca_cross_account_assume_role.name
  policy_arn = aws_iam_policy.cyberark_sca_cross_account_policy.arn
}

resource "aws_iam_role_policy_attachment" "cyberark_sca_cross_account_role_attached_to_account_permissions_policy" {
  role       = aws_iam_role.cyberark_sca_cross_account_assume_role.name
  policy_arn = aws_iam_policy.cyberark_account_permissions_policy.arn
}
