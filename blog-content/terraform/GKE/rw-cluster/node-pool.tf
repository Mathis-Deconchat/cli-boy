resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.project_id}-gke"
  cluster    = google_container_cluster.primary.id
  node_count = var.gke_node_count

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    labels = {
      env = var.project_id
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
