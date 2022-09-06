# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_core_subnet" "cp" {
  cidr_block                 = local.cp-subnet
  compartment_id             = var.compartment_id
  display_name               = var.label_prefix == "none" ? "control-plane" : "${var.label_prefix}-control-plane"
  dns_label                  = "cp"
  prohibit_public_ip_on_vnic = var.control_plane_type == "private" ? true : false
  route_table_id             = var.control_plane_type == "private" ? var.nat_route_id : var.ig_route_id
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "cp-endpoint" {
  cidr_block                 = local.cp-endpoint-subnet
  compartment_id             = var.compartment_id
  display_name               = var.label_prefix == "none" ? "control-plane-endpoint" : "${var.label_prefix}-control-plane-endpoint"
  dns_label                  = "cpendpoint"
  prohibit_public_ip_on_vnic = var.control_plane_type == "private" ? true : false
  route_table_id             = var.control_plane_type == "private" ? var.nat_route_id : var.ig_route_id
  security_list_ids          = [oci_core_security_list.cp-endpoint.id]
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "workers" {
  cidr_block                 = local.workers-subnet
  compartment_id             = var.compartment_id
  display_name               = var.label_prefix == "none" ? "workers" : "${var.label_prefix}-workers"
  dns_label                  = "workers"
  prohibit_public_ip_on_vnic = var.worker_type == "private" ? true : false
  route_table_id             = var.worker_type == "private" ? var.nat_route_id : var.ig_route_id
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "service-lb-int-subnet" {
  cidr_block                 = local.service-lb-int-subnet
  compartment_id             = var.compartment_id
  display_name               = var.label_prefix == "none" ? "svc-lb-int" : "${var.label_prefix}-svc-lb-int"
  dns_label                  = "intlb"
  prohibit_public_ip_on_vnic = true
  route_table_id             = var.nat_route_id
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "internal" || var.load_balancers == "both" ? 1 : 0
}

resource "oci_core_subnet" "service-lb-pub-subnet" {
  cidr_block                 = local.service-lb-pub-subnet
  compartment_id             = var.compartment_id
  display_name               = var.label_prefix == "none" ? "svc-lb-pub" : "${var.label_prefix}-svc-lb-pub"
  dns_label                  = "publb"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "public" || var.load_balancers == "both" ? 1 : 0
}
