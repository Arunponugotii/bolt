variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster"
  type        = string
}

variable "machine_type" {
  description = "The machine type for cluster nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_count" {
  description = "The number of nodes in the cluster"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "The disk size for cluster nodes in GB"
  type        = number
  default     = 20
}