variable "vpc" {
  type = "map"
  default = {
    main          = "10.0.0.0/16"
    subnet-1a-public = "10.0.32.0/20"
    subnet-1b-public = "10.0.96.0/20"
  }
}

variable "env" {
  default = "staging"
}

variable "region" {
  default     = "us-east-1"

}

variable "external-ip" {
  default = "0.0.0.0/0"
}

variable "cluster_defaults" {
  type        = "map"
  default = {
    name = "eks-cluster"
  }
}

variable "nodes_defaults" {
  description = "Default values for target groups as defined by the list of maps."
  type        = "map"

  default = {
    name                 = "eks-nodes"
    ami_id               = "ami-dea4d5a1"

    asg_desired_capacity = "2"
    asg_max_size         = "3"
    asg_min_size         = "2"
    instance_type        = "t2.small"
    key_name             = "k8s-key"
    ebs_optimized        = false
    public_ip            = true
  }
}

variable "client_defaults"{
  type = "map"
  default ={
    name = "eks-client"
    ami_id      = "ami-05b9703569bc15894"
    public_ip            = true
    key_name             = "k8s-key"
    instance_type = "t2.micro"
  }
}

variable "prometheus_defaults"{
  type = "map"
  default ={
    name = "prometheus-server"
    ami_id      = "ami-04169656fea786776"
    public_ip            = true
    key_name             = "k8s-key"
    instance_type = "t2.micro"
  }
}

variable "s3-bucket-name"{
  type = "string"
  default = "elk-state-files"
}

variable "access-id" {
  type = "string"
  default = "xxxx"

}

variable "access-key"{
  type = "string"
  default = "xxxx"
}
