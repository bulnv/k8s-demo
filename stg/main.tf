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
  pool_nodes_count  = 2
  k8s_node_type     = "n1-standard-2"
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

provider "helm" {}


resource "helm_release" "local" {
  name             = "sock-shop"
  chart            = "../helm-chart"
  create_namespace = true
  values = [
    "${file("chart-values.yaml")}"
  ]
  force_update  = true
  recreate_pods = true
}