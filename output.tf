output "karpenter_role_arn" {
  value       = var.create_karpenter_iam_role ? module.karpenter.iam_role_arn : var.existing_karpenter_iam_role_arn
  description = "Karpenter controller role ARN from the EKS karpenter sub-module"
}

output "karpenter_instance_profile_id" {
  value       = var.create_karpenter_iam_role ? aws_iam_instance_profile.karpenter[0].id : var.existing_karpenter_instance_profile
  description = "Karpenter instance profile ID"
}

output "karpenter_instance_profile_name" {
  value       = var.create_karpenter_iam_role ? aws_iam_instance_profile.karpenter[0].name : var.existing_karpenter_instance_profile
  description = "Karpenter instance profile name"
}

output "karpenter_sqs_name" {
  value       = module.karpenter.queue_name
  description = "SQS interruption queue name from the EKS karpenter sub-module"
}

output "karpenter_sqs_arn" {
  value       = module.karpenter.queue_arn
  description = "SQS interruption queue ARN from the EKS karpenter sub-module"
}
