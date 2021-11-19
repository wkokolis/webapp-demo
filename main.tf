/* -------------------------------------------------------------------------
   CREATE OR UPDATE THE SERVICE
   ------------------------------------------------------------------------- */
module "service" {
  source                        = "./modules/k8s_nodeport"
  service_name                  = var.service_name
  service_account_name          = var.service_account_name
  namespace                     = var.namespace
  mem_ask                       = var.mem_ask
  mem_limit                     = var.mem_limit
  replicas                      = var.replicas
  internal_port                 = var.internal_port
  external_port			= var.external_port
  ready_path                    = var.ready_probe
  live_path                     = var.live_probe
  registry                      = var.registry
  image                         = var.image
  tag                           = var.tag
}
