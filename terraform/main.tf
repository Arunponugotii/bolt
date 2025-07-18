provider "google" {
  project = var.project_id
  region  = var.region
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Simplified configuration for fast creation
  remove_default_node_pool = true
  initial_node_count       = 1

  # Service account for cluster
  node_config {
    service_account = "githubactions-sa@turnkey-guild-441104-f3.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Network configuration
  network    = "default"
  subnetwork = "default"

  # Disable features for simplified setup
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {}

  # Logging and monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Maintenance policy
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }
}

# Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    disk_type    = "pd-standard"

    # Service account
    service_account = "githubactions-sa@turnkey-guild-441104-f3.iam.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Labels
    labels = {
      env = "production"
      team = "devops"
    }

    # Metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  # Management settings
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}