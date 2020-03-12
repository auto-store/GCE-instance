provider "google" {
  project = var.project
  region = var.region
  
}


resource "google_compute_instance" "centos" {
  project      = var.project
  name         = var.instance_name
  count        = var.howmany
  machine_type = var.machine_type
  zone         = var.zone
  
  allow_stopping_for_update = true 

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

