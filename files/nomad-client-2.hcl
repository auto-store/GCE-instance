datacenter = "dr"
data_dir = "/var/lib/nomad"

client {
  enabled = true
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}

log_file = "/etc/nomad.d/logs"

retry_join = ["provider=gce tag_value=dr"]