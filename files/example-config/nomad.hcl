job "nginx" {
  datacenters = ["london"]
  type = "service"
  
  group "nginx" {
    count = 1

    volume "mysql" {
      type      = "csi"
      read_only = false
      source    = "mysql"
    }


    task "nginx" {
      driver = "docker"

      volume_mount {
        volume      = "mysql"
        destination = "/etc/nginx/conf.d/default.conf"
        read_only   = false
      }

      config {
        image = "nginx"
        port_map {
          http = 8080
        }
        port_map {
          https = 443
        }
      }
    }
    
  
    service {
        name = "nginx"
        tags = [ "nginx", "web", "urlprefix-/nginx" ]
        port = "http"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  
}