# From https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf

module "karpenter_irsa_role" {
  source                             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                            = "5.32.0"
  role_name                          = "${var.cluster_name}-karpenter"
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id         = var.cluster_name
  karpenter_controller_node_iam_role_arns = flatten([var.controller_node_iam_role_arn, var.additional_controller_node_iam_role_arns])

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  role_policy_arns = {
    "sqs_policy" = aws_iam_policy.sqs.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"]
    }
  }
  tags = local.tags
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "${var.cluster_name}-karpenter-${var.controller_nodegroup_name}"
  role = split("/", var.controller_node_iam_role_arn)[1]
  tags = local.tags
}