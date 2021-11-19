/* -------------------------------------------------------------------------
   VARIABLES
   ------------------------------------------------------------------------- */
variable "environment" {
  description                   = "Which environment to run as?  Must be one of 'demo' or 'prod'."
}
variable "service_name" {
  default                       = "cicd-demo"
  description                   = "The deployment/pod name.  Cannot use underscores."
}
variable "service_account_name" {
  default                       = "default"
  description                   = "Which service account to run under."
}
variable "namespace" {
  default                       = "default"
  description                   = "Which namespace to run in."
}
variable "mem_ask" {
  default                       = "64Mi"
  description                   = "Starting/minimum memory allocation in mibibytes."
}
variable "mem_limit" {
  default                       = "1025Mi"
  description                   = "Maximum memory allowed in mibibytes.  Exceeding this will result in out of memory errors and pod termination."
}
variable "replicas" {
  default                       = "2"
  description                   = "How many pods to launch for this deployment."
}
variable "external_port" {
  default                       = "31000"
  description                   = "The port that we expose to the network."
}
variable "internal_port" {
  default                       = "5000"
  description                   = "The port that the application listens on."
}
variable "ready_probe" {
  default                       = "/v1/liveness"
  description                   = "An HTTP-GET readiness probe."
}
variable "live_probe" {
  default                       = "/v1/liveness"
  description                   = "An HTTP-GET liveness probe."
}
variable "image" {
  default                       = "cicd-demo"
  description                   = "Image name to pull."
}
variable "registry" {
  default                       = "wkokolis"
  description                   = "Image registry to pull from"
}
variable "tag" {
  default                       = "latest"
  description                   = "Image tag to pull when no other one is specified."
}
