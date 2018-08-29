
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
  region                  = "${var.region}"
}

module "network" {
  source = "../modules/network"
  cluster_defaults = "${var.cluster_defaults}"
  vpc = "${var.vpc}"
  env = "${var.env}"
  region = "${var.region}"

}

module "cluster" {
  source = "../modules/cluster"
  vpc-id = "${module.network.vpcid}"
  subnet-1a-public = "${module.network.SubnetAPublic}"
  subnet-1b-public = "${module.network.SubnetBPublic}"
  env = "${var.env}"
  external-ip = "${var.external-ip}"
}

module "nodes" {
  source = "../modules/nodes"
  vpc-id = "${module.network.vpcid}"
  nodes_defaults = "${var.nodes_defaults}"
  cluster_defaults = "${var.cluster_defaults}"
  cluster-certificate_authority = "${module.cluster.cluster-certificate-authority}"
  subnet-1a-public = "${module.network.SubnetAPublic}"
  subnet-1b-public = "${module.network.SubnetBPublic}"
  cluster-endpoint = "${module.cluster.cluster-endpoint}"
  env = "${var.env}"
  cluster-name = "${var.cluster_defaults["name"]}"
  eks-cluster-id = "${module.cluster.eks-cluster-id}"

}

module "client"{
  source = "../modules/client"
  vpc-id = "${module.network.vpcid}"
  client_defaults = "${var.client_defaults}"
  prometheus_defaults = "${var.prometheus_defaults}"
  eks-nodes-arn = "${module.nodes.eks-nodes-arn}"
  cluster-endpoint = "${module.cluster.cluster-endpoint}"
  cluster-certificate_authority = "${module.cluster.cluster-certificate-authority}"
  access-id = "${var.access-id}"
  access-key = "${var.access-key}"
  s3-bucket-name = "${var.s3-bucket-name}"
  subnet-1a-public = "${module.network.SubnetAPublic}"
  subnet-1b-public = "${module.network.SubnetBPublic}"
  cluster_defaults = "${var.cluster_defaults}"

}

resource "aws_key_pair" "eks-prod-key" {
  key_name   = "${var.nodes_defaults["key_name"]}"
  public_key = "${var.public_key}"
}
