# From https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf

module "karpenter_irsa_role" {
  count                              = var.create_karpenter_iam_role ? 1 : 0
  source                             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                            = "5.54.1"
  role_name                          = "${var.cluster_name}-karpenter"
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_id         = var.cluster_name
  karpenter_controller_node_iam_role_arns = flatten([var.controller_node_iam_role_arn, var.additional_controller_node_iam_role_arns])

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  role_policy_arns = local.karpenter_controller_role_policy_arns

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = local.service_account_namespaces
    }
  }
  tags = local.tags
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "${var.cluster_name}-karpenter-${var.controller_nodegroup_name}"
  role = split("/", var.controller_node_iam_role_arn)[1]
  tags = local.tags
}

moved {
  from = module.karpenter_irsa_role
  to   = module.karpenter_irsa_role[0]
}