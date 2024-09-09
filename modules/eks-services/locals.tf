locals {
  kubernetes_connector_name = "${var.resource_prefix}-connector-${random_id.uniq.hex}"
}
