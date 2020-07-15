datacenter = "dr"
data_dir = "/var/lib/nomad"

server {
  enabled = true
  bootstrap_expect = 1
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}

log_file = "/etc/nomad.d/logs"

retry_join = ["provider=gce tag_value=dr"]