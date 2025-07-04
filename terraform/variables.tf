variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "my-gke-cluster"
}

variable "region" {
  description = "The GCP region for the cluster"
  type        = string
  default     = "us-central1"
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type for the nodes"
  type        = string
  default     = "e2-medium"
}

variable "disk_size" {
  description = "Disk size in GB for each node"
  type        = number
  default     = 100
}

variable "service_account_email" {
  description = "Service account email for GKE cluster and nodes"
  type        = string
  default     = "githubactions-sa@turnkey-guild-441104-f3.iam.gserviceaccount.com"
}