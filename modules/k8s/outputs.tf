output "config_path" {
  value = local_file.kubeconfig.filename
}

output "endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "client_cetrificate" {
  value = google_container_cluster.primary.master_auth.0.client_certificate
}

output "client_key" {
  value = google_container_cluster.primary.master_auth.0.client_key
}

output "ca-certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}