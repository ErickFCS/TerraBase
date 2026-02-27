resource "google_compute_firewall" "allow-http" {
  name    = "allow-http-rule"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_instance" "debian-vm" {
  name         = "lab-vm-debian"
  machine_type = "e2-micro" # Usually free-tier eligible

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  tags = ["http-server"]

  network_interface {
    network = "default"
    access_config {
      # Leaving this empty assigns a Public IP so you can SSH in later
    }
  }

  metadata_startup_script = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get install nginx -y
  echo "<h1>Hello Erick! This VM was built with Terraform and Auto-Configured.</h1>" | tee /var/www/html/index.html
  systemctl restart nginx
  EOF
}

output "vm-name" {
  value       = google_compute_instance.debian-vm.name
  description = "the vm gcloud name"
}
output "vm-zone" {
  value =  google_compute_instance.debian-vm.zone
}
output "vm-public-ip" {
  value       = google_compute_instance.debian-vm.network_interface[0].access_config[0].nat_ip
  description = "The public ip of the new vm"
}
