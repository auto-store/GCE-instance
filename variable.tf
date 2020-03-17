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
  default     = "vault-consul-dev"
}

variable "network" {
 description = "network interface to use"
 default     = "default"
}
