resource "google_compute_instance" "clients" {
  for_each     = toset(var.client_instance_name)
  project      = var.project
  name         = (each.value)
  machine_type = var.client_instance_size
  zone         = var.zone
  allow_stopping_for_update = true
  
  
  service_account {
    scopes = ["cloud-platform"]
  } 

  tags = ["dev-stack"]  

  provisioner "remote-exec" {
    inline = [ 
       "sudo useradd --system --home /etc/consul.d --shell /bin/false consul",
       "sudo mkdir -p /opt/consul",
       "sudo chown -R consul:consul /opt/consul",
       "consul -autocomplete-install",
       "complete -C /usr/local/bin/consul consul",  
       "sudo git clone https://github.com/auto-store/GCE-instance /home/tharris/GCE-instance"
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
       "sudo ansible-playbook /home/tharris/GCE-instance/files/consul.yml",
       "sudo ansible-playbook /home/tharris/GCE-instance/files/nomad-client.yml"
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

resource "google_compute_disk" "pxstorage" {
  for_each = toset(var.client_instance_name)
  name  = (each.value)
  type  = "pd-ssd"
  zone = var.zone
  size = "10" 
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.pxstorage[each.value]
  instance = google_compute_instance.clients[each.value]
  for_each = toset(var.client_instance_name)
}
