terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Define local values for zones (a and c)
locals {
  node_zones = [
    "${var.region}-a",
    "${var.region}-c"
  ]
}

# Create the GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Allow deletion without protection
  deletion_protection = false

  # Specify node locations (zones) for the cluster
  node_locations = local.node_zones

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"

  # Enable network policy for security
  network_policy {
    enabled = true
  }

  # Enable IP aliasing
  ip_allocation_policy {}

  # Enable workload identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Enable logging and monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}

# Create the node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.enable_autoscaling ? null : var.node_count

  # Specify node locations (zones) for the node pool
  node_locations = local.node_zones



  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"

    # Google service account will be used automatically
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = "production"
    }

    tags = ["gke-node", "${var.cluster_name}-node"]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}