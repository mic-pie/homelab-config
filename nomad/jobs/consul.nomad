job "consul" {
  datacenters = ["dc1"]
  type = "system"

  group "consul" {
    constraint {
      attribute = "${node.meta.role}"
      operator  = "contains"
      value     = "auth"
    }

    volume "nomad-volumes" {
      type      = "host"
      source    = "nomad-volumes"
      read_only = false
    }

    network {
      port "http" {
        static = 8500
      }
    }

    task "consul" {
      driver = "docker"

      config {
        image = "hashicorp/consul:1.18"
        args = [
          "agent",
          "-server",
          "-ui",
          "-client=0.0.0.0",
          "-bootstrap-expect=3",
          "-retry-join=docker-001.local.mphs.pl",
          "-retry-join=docker-002.local.mphs.pl",
          "-retry-join=raspberrypi-001.local.mphs.pl"
        ]
        volumes = [
          "local/nomad-volumes/consul/data:/consul/data"
        ]
      }

      volume_mount {
        volume      = "nomad-volumes"
        destination = "local/nomad-volumes"
      }

      resources {
        cpu    = 200
        memory = 128
      }

      service {
        name = "consul"
        port = "http"
        tags = ["ui"]
      }
    }
  }
}
