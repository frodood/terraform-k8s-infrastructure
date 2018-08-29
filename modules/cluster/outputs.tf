
output "cluster-endpoint" {
  value = "${aws_eks_cluster.eks-cluster.endpoint}"
}

output "cluster-certificate-authority" {
  value = "${aws_eks_cluster.eks-cluster.certificate_authority.0.data}"
}

output "eks-cluster-id"{
  value = "${aws_security_group.eks-cluster.id}"
}

output "cluster-name"{
  value = "${var.cluster_defaults["name"]}"
}
