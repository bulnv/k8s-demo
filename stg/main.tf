locals {
  region               = "europe-west1"
  zone                 = "europe-west1-b"
  kubeconfig_file_path = "kubeconfig"
}

module "k8s-stg" {
  env               = "stg"
  k8s_admin_name    = "nvbulashev"
  k8s_cluster_name  = "app"
  k8s_location      = local.zone
  k8s_pool_location = local.zone
  k8s_node_type     = "n1-standard-2"
  pool_nodes_count  = 2
  region            = local.region
  source            = "../modules/k8s"
  zone              = local.zone
  release_values_file = file("chart-values.yaml")
}

provider "google" {
  project     = "mineral-silicon-271819"
  region      = local.region
  zone        = local.zone
  credentials = file("/home/bulashev/.config/gcloud/mineral.json")
}

terraform {
  backend "gcs" {
    bucket = "nvbulashev-gke-stg-remote-states"
    prefix = "terraform/state/stg"
  }
}