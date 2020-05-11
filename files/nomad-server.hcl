datacenter = "london"
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
