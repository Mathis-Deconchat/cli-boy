variable "project_id" {
  description = "project id"
  type = string  
}

variable "region" {
  description = "region"
  type = string
}

variable "gke_node_count" {
  description = "number of nodes in the GKE cluster"
  type = number
  default = 1
}

