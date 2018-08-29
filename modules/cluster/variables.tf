variable "external-ip" {
  default = "0.0."
}

variable "cluster_defaults" {
  type        = "map"
  default = {
    name = "eks-cluster"
  }
}

variable "env" {
  default = ""
}

variable "vpc-id"{
  default = ""
}

variable "subnet-1a-public"{
  default = ""
}
variable "subnet-1b-public"{
  default = ""
}
