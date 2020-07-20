locals {
  region = "europe-west1"
  zone   = "europe-west1-b"
}
module "k8s-stg" {
  source            = "../modules/k8s"
  region            = local.region
  zone              = local.zone
  k8s_cluster_name  = "app"
  k8s_admin_name    = "nvbulashev"
  k8s_pool_location = local.zone
  k8s_location      = local.zone
  env               = "stg"
  pool_nodes_count  = 1
}

provider "google" {
  project     = "mineral-silicon-271819"
  region      = local.region
  zone        = local.zone
  credentials = "${file("/home/bulashev/.config/gcloud/mineral.json")}"
}

terraform {
  backend "gcs" {
    bucket = "nvbulashev-gke-stg-remote-states"
    prefix = "terraform/state/stg"
  }
}