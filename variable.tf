variable "project" {}

variable "instance_name" {
  description = "GCE instance name"
}

variable "machine_type" {
  description = "size of GCE machine"
  default     = "g1-small"
}

variable "zone" {
  description = "GCP zone"
  default     = "europe-west2-c"
}

variable "region" {
  description = "GCP region"
  default     = "europe-west2"
}

variable "boot_image" {
  description = "GCE image to use"
  default     = "stacker-server-1"
}

variable "network" {
 description = "network interface to use"
 default     = "default"
}

variable "encrypt" {
 description = "consul token"
}

variable "client_instance_name" {
  type = set(string)
}

variable "client_instance_size" {}

variable "ssh_user" {}

variable "private_key" {}


