# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# for reuse

output "ig_route_id" {
  description = "id of route table to vcn internet gateway"
  value       = local.ig_route_id
}

output "nat_route_id" {
  description = "id of route table to nat gateway attached to vcn"
  value       = local.nat_route_id
}

output "subnet_ids" {
  description = "map of subnet ids (worker, int_lb, pub_lb) used by OKE."
  value       = module.network.subnet_ids
}

output "vcn_id" {
  description = "id of vcn where oke is created. use this vcn id to add additional resources"
  value       = local.vcn_id
}

# convenient output

# output "bastion_public_ip" {
#   description = "public ip address of bastion host"
#   value       = local.bastion_public_ip
# }

# output "operator_private_ip" {
#   description = "private ip address of operator host"
#   value       = local.operator_private_ip
# }

# output "ssh_to_operator" {
#   description = "convenient command to ssh to the operator host"
#   value       = "ssh -i ${var.ssh_private_key_path} -J opc@${local.bastion_public_ip} opc@${local.operator_private_ip}"
# }

# output "ssh_to_bastion" {
#   description = "convenient command to ssh to the bastion host"
#   value       = "ssh -i ${var.ssh_private_key_path} opc@${local.bastion_public_ip}"
# }

# output "bastion_service_instance_id" {
#   value = var.create_bastion_service == true ? module.bastionsvc[0].bastion_id : "null"
# }
