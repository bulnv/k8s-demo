
resource "google_container_cluster" "primary" {
  name                     = format("nvbulashev-%s-%s-cluster", var.k8s_cluster_name, var.env)
  location                 = var.k8s_location == "" ? var.region : var.k8s_location
  remove_default_node_pool = true
  initial_node_count       = 1
  master_auth {
    username = var.k8s_admin_name
    password = "MMBxR6uREjBJviJy"
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = format("nvbulashev-%s-%s-pool", var.k8s_cluster_name, var.env)
  cluster    = google_container_cluster.primary.name
  node_count = var.pool_nodes_count
  location   = var.k8s_pool_location == "" ? var.region : var.k8s_pool_location

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    min_node_count = var.autoscaling_enabled ? var.min_node_count : var.pool_nodes_count
    max_node_count = var.autoscaling_enabled ? var.max_node_count : var.pool_nodes_count
  }
}