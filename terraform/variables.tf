variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "my-gke-cluster2"
}

variable "region" {
  description = "The GCP region for the cluster"
  type        = string
  default     = "us-central1"
}

variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 3
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

variable "enable_autoscaling" {
  description = "Enable autoscaling for the node pool"
  type        = bool
  default     = false
}

variable "min_nodes" {
  description = "Minimum number of nodes in the autoscaling node pool"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes in the autoscaling node pool"
  type        = number
  default     = 5
}