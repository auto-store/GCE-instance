provider "google" {
  project = var.project
  region = var.region
}
resource "google_compute_instance" "consul-server" {
  for_each     = toset(var.instance_name)
  project      = var.project
  name         = (each.value)
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true

  provisioner "remote-exec" {
    inline = [ 
       "sudo useradd --system --home /etc/consul.d --shell /bin/false consul",
       "sudo mkdir --parents /opt/consul",
       "sudo chown --recursive consul:consul /opt/consul", 
       "git clone https://github.com/auto-store/GCE-instance",
    ]
  
  connection {
      type        = "ssh"
      user        = var.ssh_user  
      private_key = var.private_key
      host        = self.network_interface[0].access_config[0].nat_ip
    }

  }

  provisioner "remote-exec" {
    inline = [ 
       "sudo ansible-playbook /home/tomh/GCE-instance/files/consul.yml"
    ]
  
  connection {
      type        = "ssh"
      user        = var.ssh_user  
      private_key = var.private_key
      host        = self.network_interface[0].access_config[0].nat_ip
    }

  }

  boot_disk {
    initialize_params {
      image = var.boot_image
    }
  }
  network_interface {
    network = var.network
    access_config {
    }
  }
}


