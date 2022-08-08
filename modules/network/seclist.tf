# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl
resource "oci_core_security_list" "control_plane_seclist" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "control-plane" : "${var.label_prefix}-control-plane"
  vcn_id         = var.vcn_id

  egress_security_rules {

    description      = "Allow Bastion service to communicate to the control plane endpoint. Required for when using OCI Bastion service."
    destination      = local.cp-subnet
    destination_type = "CIDR_BLOCK"
    protocol         = local.tcp_protocol
    stateless        = false

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    description = "Allow Bastion service to communicate to the control plane endpoint. Required for when using OCI Bastion service."
    protocol    = local.tcp_protocol
    source      = local.cp-endpoint-subnet
    source_type = "CIDR_BLOCK"
    stateless   = false

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  lifecycle {
    ignore_changes = [
      egress_security_rules, ingress_security_rules, defined_tags
    ]
  }
}
