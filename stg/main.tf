locals {
  region               = "europe-west1"
  zone                 = "europe-west1-b"
  kubeconfig_file_path = "kubeconfig"
}

data "google_client_config" "default" {}

module "k8s-stg" {
  source            = "../modules/k8s"
  region            = local.region
  zone              = local.zone
  k8s_admin_name    = "nvbulashev"
  k8s_cluster_name  = "app"
  k8s_file_path     = local.kubeconfig_file_path
  k8s_location      = local.zone
  k8s_pool_location = local.zone
  env               = "stg"
  pool_nodes_count  = 2
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
    bucket = "nvbulashev-gke-stg-remote-states"
    prefix = "terraform/state/stg"
  }
}

provider "helm" {
  kubernetes {
    host                   = format("https://%s", module.k8s-stg.endpoint)
    client_certificate     = base64decode(module.k8s-stg.client_cetrificate)
    client_key             = base64decode(module.k8s-stg.client_key)
    cluster_ca_certificate = base64decode(module.k8s-stg.ca-certificate)
    load_config_file       = false
    token                  = data.google_client_config.default.access_token
  }
}


resource "helm_release" "local" {
  name             = "sock-shop"
  chart            = "../helm-chart"
  create_namespace = true
  values = [
    "${file("chart-values.yaml")}"
  ]
  force_update  = true
  recreate_pods = true
  namespace     = "sock-shop"
  depends_on    = [module.k8s-stg]
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
  depends_on    = [module.k8s-stg]
}