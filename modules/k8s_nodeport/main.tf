/* -------------------------------------------------------------------------
   SET UP DEPLOYMENT AND SERVICE
   ------------------------------------------------------------------------- */
resource "kubernetes_deployment" "dep" {
  metadata {
    name                        = var.service_name
    namespace			= var.namespace
    labels                      = {
      app                       = var.service_name
    }
    annotations			= {
      "ad.datadoghq.com/${var.service_name}.logs" = "service: ${var.service_name}"
    }
  }

  spec {
    replicas                    = var.replicas
    min_ready_seconds		= 10

    selector {
      match_labels              = {
        app                     = var.service_name
      }
    }
    template {
      metadata {
        labels                  = {
          app                   = var.service_name
        }
      }
      spec {
        service_account_name	= var.service_account_name
        container {
          image                 = "${var.registry}/${var.image}:${var.tag}"
          image_pull_policy	= var.image_pull
          name                  = var.service_name
          resources {
            limits {
              cpu               = var.cpu_limit
              memory            = var.mem_limit
            }
            requests {
              cpu               = var.cpu_ask
              memory            = var.cpu_limit
            }
          }
          port {
            container_port      = var.internal_port
          }
          readiness_probe {
            initial_delay_seconds	= var.ready_delay
            period_seconds	= var.ready_period
            timeout_seconds	= var.ready_timeout
            failure_threshold	= var.failure_thresh
            success_threshold	= var.success_thresh
            http_get {
              path		= var.ready_path
              port		= var.internal_port
            }
          }
          liveness_probe {
            initial_delay_seconds       = var.live_delay
            period_seconds      = var.live_period
            timeout_seconds     = var.live_timeout
            failure_threshold   = var.failure_thresh
            success_threshold   = var.success_thresh
            http_get {
              path              = var.live_path
              port              = var.internal_port
            }
          }
          dynamic "env" {
            for_each 		= var.environment_variables
            content {
              name		= env.key
              value		= env.value
            }
          }
          dynamic "volume_mount" {
            for_each		= var.volume_mounts
            content {
              name		= volume_mount.key
              mount_path	= volume_mount.value
            }
          }
        }
        dynamic "volume" {
          for_each		= var.configmaps
          content {
            name		= volume.key
            config_map {
              name		= volume.value
            }
          }
        }
        dynamic "volume" {
          for_each              = var.secrets
          content {
            name                = volume.key
            secret {
              secret_name       = volume.value
            }
          }
        }
        dynamic "volume" {
          for_each              = var.persistent_volumes
          content {
            name                = volume.key
            persistent_volume_claim {
              claim_name       = volume.value
            }
          }
        }
        restart_policy		= "Always"
      }
    }
  }
}

resource "kubernetes_service" "svc" {
  metadata {
    name                        = var.service_name
    namespace                   = var.namespace
  }
  spec {
    selector                    = {
      app                       = kubernetes_deployment.dep.metadata.0.labels.app
    }
    type                        = "NodePort"
    port {
      port                      = var.external_port
      target_port               = var.internal_port
      node_port			= var.external_port
    }
  }
}
