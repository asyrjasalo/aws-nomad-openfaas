variable "namespace" {
  default = "openfaas"
}

variable "ssh_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "min_servers" {
  default = "1"
}

variable "max_servers" {
  default = "5"
}

variable "min_agents" {
  default = "1"
}

variable "max_agents" {
  default = "5"
}

variable "consul_version" {
  default = "1.0.0"
}

variable "nomad_version" {
  default = "0.8.3"
}

variable "vault_version" {
  default = "0.10.1"
}

variable "vpc_cidr_block" {
  default = "192.168.0.0/16"
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "alb_subnets" {
  default = ["192.168.1.0/16", "192.168.2.0/16", "192.168.3.0/16"]
}

variable "instance_type" {
  default = "t2.medium"
}
