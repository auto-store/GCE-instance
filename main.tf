provider "google" {
  project = var.project
  region = var.region
}
resource "google_compute_instance" "centos" {
  for_each     = toset(var.instance_name)
  project      = var.project
  name         = (each.value)
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
