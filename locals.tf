locals {
  tags = merge(
    {
      "terraform-module" = "cluster-iam-karpenter"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
}