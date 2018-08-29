variable "env" {
  default = ""
}


variable "nodes_defaults" {
  type        = "map"
  default = {
    name                 = ""
    ami_id               = ""

    asg_desired_capacity = ""
    asg_max_size         = ""
    asg_min_size         = ""
    instance_type        = ""
    key_name             = ""
    ebs_optimized        = ""
    public_ip            = ""
  }
}

variable "vpc-id"{
  default = ""
}

variable "eks-cluster-id"{
  default = ""
}

variable "cluster-certificate_authority"{
  default = ""
}

variable "subnet-1a-public"{
  default = ""
}
variable "subnet-1b-public"{
  default = ""
}
variable "cluster-name"{
  default = ""
}
variable "cluster-endpoint"{
  default = ""
}
variable "cluster_defaults" {
  type        = "map"
  default = {
    name = ""
  }
}
