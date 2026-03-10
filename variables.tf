################################################################################
# Global
################################################################################

variable "cluster_name" {
  description = "Cluster Name to install karpenter"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}

variable "disable_default_tags" {
  description = "Disable default tags for the resources created"
  type        = bool
  default     = false
}

################################################################################
# Karpenter 
################################################################################

variable "k8s_service_account_name" {
  description = "The k8s karpenter service account name"
  type        = string
  default     = "karpenter"
}

variable "k8s_service_account_namespace" {
  description = "The k8s karpenter namespace"
  type        = string
  default     = "kube-system"
}

variable "controller_nodegroup_name" {
  description = "The initial nodegroup name"
  type        = string
}

variable "karpenter_iam_role_name_prefix_enabled" {
  description = "Boolean flag to enable/disable using name prefix for karpenter iam role"
  type        = bool
  default     = false
}

################################################################################
# Karpenter Controller IAM role
################################################################################

variable "create_karpenter_iam_role" {
  description = "Enable/disable creation of IAM role for karpenter"
  type        = bool
  default     = true
}

variable "existing_karpenter_iam_role_arn" {
  description = "ARN of the existing karpenter role. This will be used only when create_karpenter_iam_role is set to false"
  type        = string
  default     = ""
}

variable "karpenter_iam_role_enable_override" {
  description = "Enable/disable override of the node iam role for the initial node group to be used by karpenter. If this is set to true, the karpenter_iam_role_override_name will be used."
  type        = bool
  default     = false
}

variable "karpenter_iam_role_override_name" {
  description = "The name of the node iam role to be used by karpenter. This will be used only when karpenter_iam_role_enable_override is set to true"
  type        = string
  default     = ""
}

variable "controller_node_iam_role_arn" {
  description = "The node iam role for the initial node group to be used by karpenter"
  type        = string
}

variable "existing_karpenter_instance_profile" {
  description = "Instance profile for karpenter. This will be used only when create_karpenter_iam_role is set to false"
  type        = string
  default     = ""
}

variable "karpenter_iam_role_additional_policy_arns" {
  description = "ARNs of additional policies to attach to the karpenter IAM role. For example {'x-policy' = arn:aws:iam::123456789012:policy/x-policy})"
  type        = any
  default     = {}
}

variable "karpenter_iam_role_permissions_boundary_arn" {
  description = "The permissions boundary ARN to be used by the karpenter IAM role"
  type        = string
  default     = ""
}

################################################################################
# SQS
################################################################################

variable "sqs_enable_encryption" {
  description = "Enable Server side encryption for SQS"
  type        = bool
  default     = true
}

variable "sqs_override_name" {
  description = "Override name for the SQS queue created for karpenter spot interruption handling."
  type        = string
  default     = ""
}

variable "sqs_enable_override" {
  description = "Enable/disable override of the SQS queue name for karpenter spot interruption handling"
  type        = bool
  default     = false
}
