mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
    }
  }

  mock_data "aws_partition" {
    defaults = {
      partition = "aws"
    }
  }

  mock_data "aws_region" {
    defaults = {
      region = "us-east-1"
    }
  }

  mock_data "aws_service_principal" {
    defaults = {
      name = "ec2.amazonaws.com"
    }
  }

  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::123456789012:role/mock-role"
    }
  }

  mock_resource "aws_sqs_queue" {
    defaults = {
      arn = "arn:aws:sqs:us-east-1:123456789012:mock-queue"
    }
  }
}

run "tags_applied" {
  command = plan

  variables {
    cluster_name                 = "test-cluster"
    controller_node_iam_role_arn = "arn:aws:iam::123456789012:role/test-node-role"
    controller_nodegroup_name    = "test-nodegroup"
    tags = {
      "cost-center" = "test-123"
    }
  }

  assert {
    condition     = aws_iam_instance_profile.karpenter[0].tags["cost-center"] == "test-123"
    error_message = "Expected caller tag cost-center=test-123 on aws_iam_instance_profile.karpenter"
  }

  assert {
    condition     = aws_iam_instance_profile.karpenter[0].tags["terraform-module"] == "karpenter"
    error_message = "Expected terraform-module=karpenter on aws_iam_instance_profile.karpenter"
  }
}
