# From https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf

data "aws_partition" "current" {}

module "karpenter_irsa_role" {
  count                              = var.create_karpenter_iam_role && !var.disable_old_changes ? 1 : 0
  source                             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                            = "5.59.0"
  role_name                          = var.karpenter_iam_role_enable_override ? var.karpenter_iam_role_override_name : "${var.cluster_name}-karpenter"
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id         = var.cluster_name
  karpenter_controller_node_iam_role_arns = flatten([var.controller_node_iam_role_arn, var.additional_controller_node_iam_role_arns])

  karpenter_controller_ssm_parameter_arns = ["arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/aws/service/*"]
  attach_vpc_cni_policy                   = true
  vpc_cni_enable_ipv4                     = true

  role_policy_arns = local.karpenter_controller_role_policy_arns

  role_permissions_boundary_arn = var.karpenter_iam_role_permissions_boundary_arn

  policy_name_prefix = local.karpenter_iam_role_policy_prefix

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = local.service_account_namespaces
    }
  }
  tags = local.tags
}

resource "aws_iam_instance_profile" "karpenter" {
  count = var.create_karpenter_iam_role && !var.disable_old_changes ? 1 : 0
  name  = "${var.cluster_name}-karpenter-${var.controller_nodegroup_name}"
  role  = split("/", var.controller_node_iam_role_arn)[1]
  tags  = local.tags
}

################################################################################
# New path: terraform-aws-modules/eks karpenter sub-module (v20)
# Always active. Set disable_old_changes = true to remove the old resources
# above once the migration is complete.
#
# enable_spot_termination = true drives both the SQS interruption queue and all
# four CloudWatch event rules (no separate create_queue / create_event_rules
# flags exist in this module version).
# Pod Identity is disabled; IRSA is used to match the old-path behaviour.
################################################################################

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name = var.cluster_name

  # IAM role for the controller
  create_iam_role                   = var.create_karpenter_iam_role
  iam_role_name                     = var.karpenter_iam_role_enable_override ? var.karpenter_iam_role_override_name : "${var.cluster_name}-eks-karpenter"
  iam_role_use_name_prefix          = false
  iam_role_permissions_boundary_arn = var.karpenter_iam_role_permissions_boundary_arn != "" ? var.karpenter_iam_role_permissions_boundary_arn : null
  iam_role_policies                 = var.karpenter_iam_role_additional_policy_arns

  # IRSA – disable Pod Identity and use the cluster OIDC provider instead
  enable_pod_identity             = false
  enable_irsa                     = var.create_karpenter_iam_role
  irsa_oidc_provider_arn          = var.oidc_provider_arn
  irsa_namespace_service_accounts = local.service_account_namespaces

  # Re-use the existing node IAM role; skip creating a new one and its access entry
  create_node_iam_role = false
  node_iam_role_arn    = var.controller_node_iam_role_arn
  create_access_entry  = false

  # Instance profile (mirrors aws_iam_instance_profile.karpenter on the old path)
  create_instance_profile = var.create_karpenter_iam_role

  # SQS interruption queue + CloudWatch event rules (both controlled by this flag)
  enable_spot_termination   = true
  queue_name                = "${var.cluster_name}-karpenter"
  queue_managed_sse_enabled = var.sqs_enable_encryption

  tags = local.tags
}

moved {
  from = module.karpenter[0]
  to   = module.karpenter
}

moved {
  from = module.karpenter_irsa_role
  to   = module.karpenter_irsa_role[0]
}

moved {
  from = aws_iam_instance_profile.karpenter
  to   = aws_iam_instance_profile.karpenter[0]
}
