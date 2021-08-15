provider "template" { }

provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}

resource "google_bigtable_instance" "default" {
  project = var.project_id
  name = var.bigtable_instance_name

  cluster {
    cluster_id = "${var.bigtable_instance_name}-cluster"
    zone = var.zone
    storage_type = "HDD"
  }
}

resource "google_compute_instance" "default" {
  project = var.project_id
  zone = var.zone

  name = "datbot-sentibot"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  metadata_startup_script = data.template_cloudinit_config.config.rendered

  network_interface {
    network = "default"
    access_config { }
  }

  service_account {
    scopes = [
      "cloud-platform"
    ]
    email = google_service_account.vmaccess.email
  }

  tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  project = var.project_id
  name = "webserver5000rule"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "80",
      "5000"
    ]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = [
    "http-server"
  ]
}

output "ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

resource "google_storage_bucket" "sentiment-analysis-staging" {
  name = var.bucket_name
  location = "EU"
  force_destroy = true
}

# Render a multi-part cloud-init config making use of the part
# above, and other source files
data "template_cloudinit_config" "config" {
  gzip = false
  base64_encode = false

  part {
    filename = "script-rendered.sh"
    content_type = "text/x-shellscript"
    content = file("${path.module}/startup.tpl")
  }
}