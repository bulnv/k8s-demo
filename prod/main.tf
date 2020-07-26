locals {
  region = "europe-north1"
  zone   = "europe-north1-b"
  kubeconfig_file_path = "kubeconfig"
}

module "k8s" {
  source              = "../modules/k8s"
  autoscaling_enabled = true
  min_node_count      = 1
  max_node_count      = 2
  release_values_file = file("chart-values.yaml")
  release_create_monkey = true
  k8s_node_type     = "n1-standard-2"
}

provider "google" {
  project     = "mineral-silicon-271819"
  region      = local.region
  zone        = local.zone
  credentials = file("/home/bulashev/.config/gcloud/mineral.json")
}

terraform {
  backend "gcs" {
    bucket = "nvbulashev-gke-prod-remote-states"
    prefix = "terraform/state/prod"
  }
}
