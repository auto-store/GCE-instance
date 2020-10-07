datacenter = "dc1"
data_dir = "/var/lib/nomad"

server {
  enabled = true
  bootstrap_expect = 3
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}

log_file = "/etc/nomad.d/logs"

ui = true