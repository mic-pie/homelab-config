# Shared on all Nomad servers: /etc/nomad.d/server.hcl
server {
  enabled          = true
  bootstrap_expect = 3
  server_join {
    retry_join = [
      "docker-001.local.mphs.pl",
      "docker-002.local.mphs.pl",
      "raspberrypi-001.local.mphs.pl"
    ]
  }
}

bind_addr = "0.0.0.0"
data_dir  = "/opt/nomad"
log_level = "INFO"

# Enable client role on server nodes
client {
  enabled = true
  meta = {
    docker-installed = "true"
  }
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}

consul {
  address = "127.0.0.1:8500"
  auto_advertise = true
  client_auto_join = true
  server_auto_join = true
}
