# From https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf

resource "aws_iam_instance_profile" "karpenter" {
  count = var.create_karpenter_iam_role ? 1 : 0
  name  = "${var.cluster_name}-karpenter-${var.controller_nodegroup_name}"
  role  = split("/", var.controller_node_iam_role_arn)[1]
  tags  = local.tags
}

################################################################################
# enable_spot_termination = true drives both the SQS interruption queue and all
# four CloudWatch event rules (no separate create_queue / create_event_rules
# flags exist in this module version).
# Pod Identity is enabled; IRSA is disabled.
################################################################################

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name = var.cluster_name

  # IAM role for the controller
  create_iam_role                   = var.create_karpenter_iam_role
  iam_role_name                     = var.karpenter_iam_role_enable_override ? var.karpenter_iam_role_override_name : "${var.cluster_name}-karpenter-controller"
  iam_role_use_name_prefix          = var.karpenter_iam_role_name_prefix_enabled
  iam_role_permissions_boundary_arn = var.karpenter_iam_role_permissions_boundary_arn != "" ? var.karpenter_iam_role_permissions_boundary_arn : null
  iam_role_policies                 = var.karpenter_iam_role_additional_policy_arns

  # Re-use the existing node IAM role; skip creating a new one and its access entry
  create_node_iam_role = false
  node_iam_role_arn    = var.controller_node_iam_role_arn
  create_access_entry  = false

  # Instance profile is managed by aws_iam_instance_profile.karpenter
  create_instance_profile = false

  # Pod Identity
  enable_pod_identity             = true
  create_pod_identity_association = true
  namespace                       = var.k8s_service_account_namespace
  service_account                 = var.k8s_service_account_name

  # Disable IRSA
  enable_irsa = false

  # SQS interruption queue + CloudWatch event rules (both controlled by this flag)
  enable_spot_termination   = true
  queue_name                = var.sqs_enable_override ? var.sqs_override_name : "${var.cluster_name}-karpenter-queue"
  queue_managed_sse_enabled = var.sqs_enable_encryption

  tags = local.tags
}

moved {
  from = module.karpenter[0]
  to   = module.karpenter
}

moved {
  from = aws_iam_instance_profile.karpenter
  to   = aws_iam_instance_profile.karpenter[0]
}
