output "eks-nodes-arn"{
  value = "${aws_iam_role.eks-nodes.arn}"
}

output "autoscaling-group-name"{
  value = "${aws_autoscaling_group.autoscaling-group.name}"
}
