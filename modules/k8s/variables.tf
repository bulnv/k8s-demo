variable "region" {
  type    = string
  default = "europe-north1"
}

variable "zone" {
  type    = string
  default = "europe-north1-a"
}

variable "project" {
  type    = string
  default = "mineral-silicon-271819"
}

variable "k8s_cluster_name" {
  type    = string
  default = "app"
}

variable "k8s_admin_name" {
  type    = string
  default = "nvbulashev"
}

variable "k8s_location" {
  type    = string
  default = ""
}

variable "k8s_pool_location" {
  type    = string
  default = ""
}

variable "k8s_admin_password" {
  type    = string
  default = "MMBxR6uREjBJviJy"
}

variable "k8s_node_type" {
  type    = string
  default = "n1-standard-1"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "release_values_file" {
  type    = string
  default = "chart-values.yaml"
}

variable "release_create_monkey" {
  type    = bool
  default = false
}

variable "release_create_local" {
  type    = bool
  default = true
}

variable "pool_nodes_count" {
  type    = number
  default = 1
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 1
}

variable "autoscaling_enabled" {
  type    = bool
  default = false
}
