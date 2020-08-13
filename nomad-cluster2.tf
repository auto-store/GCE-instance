variable "server_instance_name_dr" {
}

variable "client_instance_name_dr" {
}

variable "zone_2" {
  description = "GCP zone"
  default     = "europe-west2-b"
}

resource "google_compute_instance" "nomad-server-2" {
  for_each     = toset(var.server_instance_name_dr)
  project      = var.project
  name         = (each.value)
  machine_type = var.machine_type
  zone         = var.zone_2
  allow_stopping_for_update = true


  service_account {
    scopes = ["cloud-platform"]
  } 

  tags = ["dr"]  

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
       "sudo ansible-playbook /home/GCE-instance/files/nomad-server-2.yml"
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


resource "google_compute_instance" "clients-2" {
  for_each     = toset(var.client_instance_name_dr)
  project      = var.project
  name         = (each.value)
  machine_type = var.client_instance_size
  zone         = var.zone_2
  allow_stopping_for_update = true

  service_account {
    scopes = ["cloud-platform"]
  }

  tags = ["dr"]

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
       "sudo ansible-playbook /home/GCE-instance/files/nomad-client-2.yml",
       "sudo ansible-playbook /home/GCE-instance/files/consul.yml"
       
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

// output "nomad-dr-server-ip" {
//   value = network_interface[0].access_config[0].nat_ip
// }


