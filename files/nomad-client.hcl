datacenter = "london"
data_dir = "/etc/nomad.d"

client {
  enabled = true
}

options {
   "docker.privileged.enabled" = "true"
}