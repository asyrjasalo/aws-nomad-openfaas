module "open-faas-nomad" {
  source = "./open-faas-nomad"

  namespace = "openfaas"

  instance_type = "t2.small"
  max_servers = "3"

  ssh_key = "~/.ssh/id_rsa.pub"
}

output "nomad_endpoint" {
  value = "http://${module.open-faas-nomad.nomad_alb}:4646"
}

output "openfaas_endpoint" {
  value = "http://${module.open-faas-nomad.openfaas_alb}:8080"
}

output "grafana_endpoint" {
  value = "http://${module.open-faas-nomad.openfaas_alb}:3000"
}

output "prometheus_endpoint" {
  value = "http://${module.open-faas-nomad.openfaas_alb}:9090"
}

output "vpc_id" {
  value = "${module.open-faas-nomad.vpc_id}"
}

output "security_group" {
  value = "${module.open-faas-nomad.security_group}"
}

output "route_table_id" {
  value = "${module.open-faas-nomad.route_table_id}"
}

output "subnets" {
  value = "${module.open-faas-nomad.subnets}"
}
