# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.5.0"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # gateways
  create_internet_gateway  = true
  create_nat_gateway       = true
  create_service_gateway   = true
  nat_gateway_public_ip_id = var.nat_gateway_public_ip_id
  attached_drg_id          = var.drg_id != null ? var.drg_id : (var.create_drg ? module.drg[0].drg_id : null)

  # lpgs
  local_peering_gateways = var.local_peering_gateways

  # freeform_tags
  freeform_tags = var.freeform_tags["vcn"]

  # vcn
  vcn_cidrs                    = var.vcn_cidrs
  vcn_dns_label                = var.vcn_dns_label
  vcn_name                     = var.vcn_name
  lockdown_default_seclist     = var.lockdown_default_seclist
  internet_gateway_route_rules = var.internet_gateway_route_rules
  nat_gateway_route_rules      = var.nat_gateway_route_rules

  count = var.create_vcn == true ? 1 : 0
}

module "drg" {

  source  = "oracle-terraform-modules/drg/oci"
  version = "1.0.3"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # drg parameters
  drg_display_name = var.drg_display_name
  drg_vcn_attachments = { for k, v in module.vcn : k => {
    # gets the vcn_id values dynamically from the vcn module
    vcn_id : v.vcn_id
    vcn_transit_routing_rt_id : null
    drg_route_table_id : null
    }
  }
  # var.drg_id can either contain an existing DRG ID or be null.
  drg_id = var.drg_id

  count = var.create_drg || var.drg_id != null ? 1 : 0
}

# additional networking for subnets
module "network" {
  source = "./modules/network"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # networking parameters
  ig_route_id  = local.ig_route_id
  nat_route_id = local.nat_route_id
  subnets      = var.subnets
  vcn_id       = local.vcn_id


  # control plane endpoint parameters
  control_plane_type = var.control_plane_type

  # worker network parameters
  worker_type = var.worker_type

  # oke load balancer network parameters
  load_balancers = var.load_balancers

  depends_on = [
    module.vcn
  ]
}

# nsgs for antrea cni
module "antrea" {
  source = "./modules/antrea"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # networking parameters
  subnets = var.subnets
  vcn_id  = local.vcn_id

  # control plane endpoint parameters
  control_plane_type          = "public"
  control_plane_allowed_cidrs = ["0.0.0.0/0"]

  # worker network parameters
  allow_node_port_access       = false
  allow_worker_internet_access = true
  allow_worker_ssh_access      = var.allow_worker_ssh_access
  worker_type                  = var.worker_type

  # load balancer network parameters
  load_balancers = var.load_balancers

  public_lb_allowed_cidrs = var.public_lb_allowed_cidrs
  public_lb_allowed_ports = var.public_lb_allowed_ports

  depends_on = [
    module.network
  ]
}
