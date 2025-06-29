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

# Create the GKE cluster with minimal configuration for fast creation
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

  # CRITICAL: Specify service account for the cluster's default node pool
  # Even though we remove it, we need to specify the SA to avoid using default
  node_config {
    service_account = var.service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Create the node pool with explicit service account and simplified configuration
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count  # Fixed count, no autoscaling complexity

  # Specify node locations (zones) for the node pool
  node_locations = local.node_zones

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"

    # CRITICAL: Use the GitHub Actions service account for node pool
    service_account = var.service_account_email
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
}