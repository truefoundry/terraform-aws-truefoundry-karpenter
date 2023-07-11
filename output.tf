output "karpenter_role_arn" {
  value = module.karpenter_irsa_role.iam_role_arn
}

output "karpenter_instance_profile_id" {
  value = aws_iam_instance_profile.karpenter.id
}