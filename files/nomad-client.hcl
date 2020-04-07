datacenter = "london"
data_dir = "/etc/nomad.d"

client {
  enabled = true
  options {
    "driver.raw_exec.enable" = "1"
    "docker.privileged.enabled" = "true"
  }
}

