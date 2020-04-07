datacenter = "london"
data_dir = "/etc/nomad.d"

client {
  options {
     "docker.privileged.enabled" = "true"
  }
  enabled = true
}

