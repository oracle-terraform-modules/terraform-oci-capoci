# Copyright 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_core_subnets" "subnets" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

