/* -------------------------------------------------------------------------
   VARIABLES
   ------------------------------------------------------------------------- */
variable "service_name" {
  description			= "Friendly name to identify the deployment.  Must be DNS-compliant (cannot contain underscores)."
}
variable "service_account_name" {
  default			= null
  description			= "Service account to run the pods as.  Useful for granting access to cluster resources like secrets."
}
variable "internal_port" {
  description			= "The port that the service itself listens on.  Typically 8080 for Java, 5000 for Python, and 3000 for javascript."
}
variable "external_port" {
  description			= "The port to publish the service on.  This must be between 30000 and 32767, and must be unique for the cluster."
}
variable "ready_path" {
  default			= null
  description			= "Path to the container's healthcheck.  Usually something like /health."
}
variable "ready_period" {
  description			= "How frequently to check the container's healthcheck.  Defaults to 15 seconds."
  default			= 15
}
variable "ready_delay" {
  description			= "How long to wait before starting readiness checks.  Defaults to 60 seconds."
  default			= 60
}
variable "ready_timeout" {
  default			= 5
  description			= "Number of seconds before a readiness probe times out.  Defaults to 5 seconds."
}
variable "live_path" {
  default                       = null
  description                   = "Path to the container's healthcheck.  Usually something like /health."
}
variable "live_period" {
  description                   = "How frequently to check the container's healthcheck.  Defaults to 15 seconds."
  default                       = 15
}
variable "live_delay" {
  description                   = "How long to wait before starting liveness checks.  Defaults to 180 seconds."
  default                       = 180
}
variable "live_timeout" {
  default                       = 5
  description                   = "Number of seconds before a liveness probe times out.  Defaults to 5 seconds."
}
variable "failure_thresh" {
  default			= 3
  description			= "How many times can the readiness probe fail before the pod is unhealthy?"
}
variable "success_thresh" {
  default			= 1
  description			= "How many times must the readiness probe succeed before the pod is healthy again?"
}
variable "registry_secret" {
  default			= null
  description			= "K8s secret used to pull the image.  Unnecessary if using a service account with access to the secrets."
}
variable "registry" {
  description			= "The URI of the registry housing the image.  For DockerHub-based images, use the namespace for this value.  In a namespaced private registry, use both the URI and the namespace.  Do not confuse this with the K8s namespace!"
}
variable "image" {
  description			= "The container image to pull.  Do not include the registry, namespace, or tag, as these are provided independently."
}
variable "tag" {
  default			= "latest"
  description			= "The image tag to deploy."
}
variable "environment_variables" {
  type				= map
  default 			= {}
  description			= "A map of one or more environment variables.  The key is the variable name, and the value is its value."
}
variable "volume_mounts" {
  type                          = map
  default			= {}
  description			= "A map of volumes and their mount points in the pods.  The key is the volume name, and the value is its path in the pods."
}
variable "configmaps" {
  type                          = map
  default			= {}
  description			= "A map of K8s configmaps available to the deployment.  The key is the volume name, and the value is the configmap's name."
}
variable "secrets" {
  type                          = map
  default			= {}
  description			= "A map of K8s secrets available to the deployment.  The key is the volume name, and the value is the secret's name."
}
variable "persistent_volumes" {
  type                          = map
  default                       = {}
  description                   = "A map of persistent volume claims for the deployment.  The key is the volume name, and the value is the pv's name."
}
variable "replicas" {
  default			= "1"
  description			= "How many pods to run for this deployment."
}
variable "image_pull" {
  default			= "Always"
  description			= "Should the image be pulled every time or not.  Can be 'Always', 'Never', or 'IfNotPresent'."
}
variable "cpu_ask" {
  default			= "50m"
  description			= "Minimum CPU units available per pod.  Expressed as millicores, where 1000 represents 100% of a single core/VPU."
}
variable "cpu_limit" {
  default			= "1000m"
  description			= "Upper limit on CPU available per pod."
}
variable "mem_ask" {
  default			= "128Mi"
  description			= "Lower limit on memory available per pod.  Pods may use less, but will attempt to reserve this much."
}
variable "mem_limit" {
  default			= "1024Mi"
  description			= "Upper limit on memory available per pod.  Exceeding this limit will invoke the OOM killer."
}
variable "namespace" {
  default			= "default"
  description			= "Namespace in which to run the deployment."
}
