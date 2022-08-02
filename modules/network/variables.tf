# Copyright 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# general oci parameters
variable "compartment_id" {}

variable "label_prefix" {}

# networking parameters
variable "ig_route_id" {}

variable "nat_route_id" {}

variable "subnets" {
  type = map(any)
}

variable "vcn_id" {}

# cluster endpoint

variable "control_plane_type" {
  type = string
}

# workers
variable "worker_type" {}

# load balancers

variable "load_balancers" {
  type = string
}
