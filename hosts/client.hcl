# Enable client role on server nodes too (except docker-003)
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
