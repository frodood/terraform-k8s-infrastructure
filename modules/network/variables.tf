variable "vpc" {
  type = "map"
  default = {
    main          = ""
    subnet-1a-public = ""
    subnet-1b-public = ""
  }
}

variable "env" {
  default = ""
}

variable "region" {
  default     = ""

}

variable "cluster_defaults" {
  type        = "map"
  default = {
    name = ""
  }
}
