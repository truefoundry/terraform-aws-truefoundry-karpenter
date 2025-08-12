locals {
  tags = merge(
    var.disable_default_tags ? {} : {
      "terraform-module" = "cluster-iam-karpenter"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
  events = {
    health_event = {
      name        = "HealthEvent"
      description = "Karpenter interrupt - AWS health event"
      event_pattern = {
        source      = ["aws.health"]
        detail-type = ["AWS Health Event"]
      }
    }
    spot_interupt = {
      name        = "SpotInterrupt"
      description = "Karpenter interrupt - EC2 spot instance interruption warning"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Spot Instance Interruption Warning"]
      }
    }
    instance_rebalance = {
      name        = "InstanceRebalance"
      description = "Karpenter interrupt - EC2 instance rebalance recommendation"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance Rebalance Recommendation"]
      }
    }
    instance_state_change = {
      name        = "InstanceStateChange"
      description = "Karpenter interrupt - EC2 instance state-change notification"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance State-change Notification"]
      }
    }
  }
  karpenter_controller_role_policy_arns = var.create_karpenter_iam_role ? merge(
    {
      "sqs_policy" = aws_iam_policy.sqs[0].arn
    },
    var.karpenter_iam_role_additional_policy_arns
  ) : {}
  service_account_namespaces = var.k8s_service_account_namespace == "karpenter" ? ["${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"] : ["${var.k8s_service_account_namespace}:${var.k8s_service_account_name}", "karpenter:${var.k8s_service_account_name}"]

  karpenter_iam_role_default_policy_prefix = "${var.cluster_name}-karpenter-"

  karpenter_iam_role_policy_prefix = var.karpenter_iam_role_policy_prefix_enable_override ? "${var.karpenter_iam_role_policy_prefix_override_name}-${local.karpenter_iam_role_default_policy_prefix}" : local.karpenter_iam_role_default_policy_prefix
}
