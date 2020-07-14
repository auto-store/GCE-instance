provider "google" {
  project = var.project
  region = var.region
}
resource "google_compute_instance" "nomad-server" {
  for_each     = toset(var.instance_name)
  project      = var.project
  name         = (each.value)
  machine_type = var.machine_type
  zone         = var.zone_2
  allow_stopping_for_update = true


  service_account {
    scopes = ["cloud-platform"]
  } 

  tags = ["dev-stack"]  

  provisioner "remote-exec" {
    inline = [
       "sudo git clone https://github.com/auto-store/GCE-instance /home/GCE-instance"
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
       "sudo ansible-playbook /home/GCE-instance/files/nomad.yml"
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



resource "google_compute_firewall" "hashi-stack" {
  name    = "hashi-stack"
  network = var.network
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["8200", "8500", "8300", "8301", "8302", "8201", "8600", "8605", "8606", "8607" ]
  }
  allow {
    protocol = "udp"
    ports    = ["8301", "8302", "8600", "8601"]
  }
  source_ranges = ["0.0.0.0"]
}

resource "google_compute_instance" "clients" {
  for_each     = toset(var.client_instance_name)
  project      = var.project
  name         = (each.value)
  machine_type = var.client_instance_size
  zone         = var.zone_2
  allow_stopping_for_update = true
  
  
  service_account {
    scopes = ["cloud-platform"]
  }

  tags = ["dev-stack"]

  provisioner "remote-exec" {
    inline = [
       "sudo git clone https://github.com/auto-store/GCE-instance /home/GCE-instance"
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
       "sudo ansible-playbook /home/GCE-instance/files/nomad-client.yml"
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
  type  = "pd-ssd"
  name  = "${(each.value)}-px"
  zone = var.zone_2
  size = "10"
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.pxstorage[each.key].id
  instance = google_compute_instance.clients[each.key].id
  for_each = toset(var.client_instance_name)
}
