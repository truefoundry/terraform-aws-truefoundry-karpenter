################################################################################
# Old path (disable_old_changes = false)
# All resources below are skipped when disable_old_changes = true; the EKS
# karpenter sub-module (module.karpenter) handles them instead.
################################################################################

resource "aws_sqs_queue" "karpenter" {
  count                     = var.disable_old_changes ? 0 : 1
  name                      = "${var.cluster_name}-karpenter"
  message_retention_seconds = var.message_retention_seconds
  sqs_managed_sse_enabled   = var.sqs_enable_encryption
  tags                      = local.tags
}

data "aws_iam_policy_document" "sqs" {
  count = var.disable_old_changes ? 0 : 1

  statement {
    resources = [aws_sqs_queue.karpenter[0].arn]
    actions   = ["sqs:DeleteMessage", "sqs:GetQueueUrl", "sqs:GetQueueAttributes", "sqs:ReceiveMessage"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "sqs" {
  count = var.create_karpenter_iam_role && !var.disable_old_changes ? 1 : 0
  # We need to add "access-to-sqs" to the policy prefix when karpenter_iam_role_policy_prefix_enable_override is true because if not final policy will be just be prefix-timestasmp
  name_prefix = var.karpenter_iam_role_policy_prefix_enable_override ? "${var.karpenter_iam_role_policy_prefix_override_name}access-to-sqs" : "${local.karpenter_iam_role_default_policy_prefix}access-to-sqs"
  description = "Access policy for karpenter to access SQS for ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.sqs[0].json
  tags        = local.tags
}

data "aws_iam_policy_document" "node_termination_queue" {
  count = var.disable_old_changes ? 0 : 1

  statement {
    resources = [aws_sqs_queue.karpenter[0].arn]
    sid       = "SQSWrite"
    actions   = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "karpenter" {
  count     = var.disable_old_changes ? 0 : 1
  policy    = data.aws_iam_policy_document.node_termination_queue[0].json
  queue_url = aws_sqs_queue.karpenter[0].url
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.disable_old_changes ? {} : { for k, v in local.events : k => v }

  name_prefix   = substr("${var.cluster_name}-${each.value.name}-", 0, 37)
  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.disable_old_changes ? {} : { for k, v in local.events : k => v }

  rule      = aws_cloudwatch_event_rule.this[each.key].name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.karpenter[0].arn
}

################################################################################
# State migration: resources that previously had no index now carry [0]
################################################################################

moved {
  from = aws_sqs_queue.karpenter
  to   = aws_sqs_queue.karpenter[0]
}

moved {
  from = aws_sqs_queue_policy.karpenter
  to   = aws_sqs_queue_policy.karpenter[0]
}

moved {
  from = aws_iam_policy.sqs
  to   = aws_iam_policy.sqs[0]
}
