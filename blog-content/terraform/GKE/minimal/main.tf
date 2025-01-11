provider "google" {
  project     = "cogent-octane-401014"
  region      = "europe-west9"
}

resource "google_container_cluster" "gke_cluster" {
  name               = "gke-cluster"
  location           = "europe-west9"
  initial_node_count = 3
  

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 20
  }
}

output "cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate
  sensitive = true
}