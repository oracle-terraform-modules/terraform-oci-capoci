# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {

  # first vcn cidr
  # pick the first cidr block in the list as this is where we will create the oke subnets
  vcn_cidr = element(data.oci_core_vcn.vcn.cidr_blocks, 0)

  # subnet cidrs - used by subnets
  bastion_subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["bastion"], "newbits"), lookup(var.subnets["bastion"], "netnum"))

  cp_subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["cp"], "newbits"), lookup(var.subnets["cp"], "netnum"))

  int_lb_subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["int_lb"], "newbits"), lookup(var.subnets["int_lb"], "netnum"))

  operator_subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["operator"], "newbits"), lookup(var.subnets["operator"], "netnum"))

  pub_lb_subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["pub_lb"], "newbits"), lookup(var.subnets["pub_lb"], "netnum"))

  workers_subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["workers"], "newbits"), lookup(var.subnets["workers"], "netnum"))

  anywhere = "0.0.0.0/0"

  # port numbers
  ssh_port = 22

  # protocols
  # # special OCI value for all protocols
  all_protocols = "all"

  # # IANA protocol numbers
  icmp_protocol = 1

  tcp_protocol = 6

  udp_protocol = 17

  # oracle services network
  osn = lookup(data.oci_core_services.all_oci_services.services[0], "cidr_block")

}
