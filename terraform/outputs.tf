output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_location" {
  description = "GKE cluster location"
  value       = google_container_cluster.primary.location
}

output "cluster_ca_certificate" {
  description = "GKE cluster CA certificate"
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  sensitive   = true
}

output "node_pool_name" {
  description = "GKE node pool name"
  value       = google_container_node_pool.primary_nodes.name
}

output "service_account_email" {
  description = "Service account email used by cluster and nodes"
  value       = var.service_account_email
}

output "node_zones" {
  description = "Node zones for the cluster"
  value       = local.node_zones
}