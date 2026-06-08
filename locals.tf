locals {
  tags = merge(
    var.disable_default_tags ? {} : {
      "truefoundry-terraform-module" = "karpenter"
      "truefoundry-managed"          = "true"
      "truefoundry-cluster-name"     = var.cluster_name
    },
    var.tags
  )
}
