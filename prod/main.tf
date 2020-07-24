locals {
  region = "europe-north1"
  zone   = "europe-north1-b"
}
module "k8s-stg" {
  source              = "../modules/k8s"
  autoscaling_enabled = true
  min_node_count      = 1
  max_node_count      = 2
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

resource "helm_release" "kubemonkey" {
  name             = "kubemonkey"
  chart            = "../kubemonkey"
  create_namespace = true
  values = [
    "${file("../kubemonkey/values.yaml")}"
  ]
  force_update  = true
  recreate_pods = true
}