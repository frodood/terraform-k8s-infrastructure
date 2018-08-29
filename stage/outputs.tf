output "VPCID" {
  value = "${module.network.vpcid}"

}

output "PublicSubnets" {
  value = "${module.network.PublicSubnets}"
}

output "cluster-endpoint" {
  value = "${module.cluster.cluster-endpoint}"
}


output "cluster-name"{
  value = "${module.cluster.cluster-name}"
}

output "autoscaling-group-name"{
  value = "${module.nodes.autoscaling-group-name}"
}

output "kubectl-client-public_ip"{
  value = "${module.client.kubectl-client-public-ip}"
}

output "kubectl-client-private"{
  value = "${module.client.kubectl-client-private-ip}"
}


output "prometheus-server-public-ip" {
  value = "${module.client.prometheus-server-public-ip}"
}
