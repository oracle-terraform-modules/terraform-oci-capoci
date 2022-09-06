# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {

  # first vcn cidr
  # pick the first cidr block in the list as this is where we will create the oke subnets
  vcn_cidr = element(data.oci_core_vcn.vcn.cidr_blocks, 0)

  # subnet cidrs - used by subnets
  bastion-subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["bastion"], "newbits"), lookup(var.subnets["bastion"], "netnum"))

  operator-subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["operator"], "newbits"), lookup(var.subnets["operator"], "netnum"))

  cp-endpoint-subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["cp-endpoint"], "newbits"), lookup(var.subnets["cp-endpoint"], "netnum"))

  cp-subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["cp"], "newbits"), lookup(var.subnets["cp"], "netnum"))

  service-lb-int-subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["service-lb-int"], "newbits"), lookup(var.subnets["service-lb-int"], "netnum"))

  service-lb-pub-subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["service-lb-pub"], "newbits"), lookup(var.subnets["service-lb-pub"], "netnum"))

  workers-subnet = cidrsubnet(local.vcn_cidr, lookup(var.subnets["workers"], "newbits"), lookup(var.subnets["workers"], "netnum"))

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

  # port numbers
  health_check_port = 10256
  node_port_min     = 30000
  node_port_max     = 32767

  # if port = -1, allow all ports

  # control plane
  cp_egress = [
    {
      description      = "Allow Kubernetes control plane to anywhere",
      destination      = local.anywhere,
      destination_type = "CIDR_BLOCK",
      protocol         = local.all_protocols,
      port             = -1,
      stateless        = false
    },
    {
      description      = "Allow control nodes to communicate with OCI services",
      destination      = local.osn,
      destination_type = "SERVICE_CIDR_BLOCK",
      protocol         = local.tcp_protocol,
      port             = -1,
      stateless        = false
    }
  ]

  cp_ingress = [
    {
      description = "Allow control plane API endpoint to control plane nodes"
      protocol    = local.tcp_protocol,
      port        = 6443,
      source      = local.cp-endpoint-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow control plane to control plane nodes (api server port)"
      protocol    = local.tcp_protocol,
      port        = 6443,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow worker nodes to control plane nodes (api server port)"
      protocol    = local.tcp_protocol,
      port        = 6443,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow control plane to control plane kubelet communication"
      protocol    = local.tcp_protocol,
      port        = 10250,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow etcd client communication"
      protocol    = local.tcp_protocol,
      port        = 2379,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow etcd peer communication"
      protocol    = local.tcp_protocol,
      port        = 2380,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Antrea service communication from control plane"
      protocol    = local.tcp_protocol,
      port        = 10349,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Antrea service communication from workers"
      protocol    = local.tcp_protocol,
      port        = 10349,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Geneve service communication from control plane"
      protocol    = local.udp_protocol,
      port        = 6081,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Geneve service communication from workers"
      protocol    = local.udp_protocol,
      port        = 6081,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Path discovery"
      protocol    = local.icmp_protocol,
      port        = -1,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow SSH Traffic to Control Plane nodes "
      protocol    = local.tcp_protocol,
      port        = -1,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    }
  ]

  # workers
  workers_egress = [
    {
      description      = "Allow all egress traffic from workers",
      destination      = local.anywhere
      destination_type = "CIDR_BLOCK",
      protocol         = local.all_protocols,
      port             = -1,
      stateless        = false
    },
  ]

  workers_ingress = [
    {
      description = "Allow incoming traffic from service load balancers (NodePort Communication)",
      protocol    = local.tcp_protocol,
      port        = 32000 - 32767,
      source      = local.service-lb-int-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow incoming traffic from service load balancers (NodePort Communication)",
      protocol    = local.tcp_protocol,
      port        = 32000 - 32767,
      source      = local.service-lb-pub-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow control plane to worker node (Kubelet Communication)",
      protocol    = local.tcp_protocol,
      port        = 10250,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow worker to worker node (Kubelet Communication)",
      protocol    = local.tcp_protocol,
      port        = 10250,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Antrea Service communication from control plane"
      protocol    = local.tcp_protocol,
      port        = 10349,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Antrea Service communication from workers"
      protocol    = local.tcp_protocol,
      port        = 10349,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Geneve Service communication from control plane"
      protocol    = local.udp_protocol,
      port        = 6081,
      source      = local.cp-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Geneve Service communication from workers"
      protocol    = local.udp_protocol,
      port        = 6081,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow Path discovery"
      protocol    = local.icmp_protocol,
      port        = -1,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    },
    {
      description = "Allow SSH Traffic to worker nodes "
      protocol    = local.tcp_protocol,
      port        = 22,
      source      = local.workers-subnet,
      source_type = "CIDR_BLOCK",
      stateless   = false
    }
  ]

  pub_lb_egress = [
    {
      description      = "Allow stateful egress to workers. Required for NodePorts",
      destination      = local.workers-subnet,
      destination_type = "CIDR_BLOCK",
      protocol         = local.tcp_protocol,
      port             = "30000-32767",
      stateless        = false
    },
    {
      description      = "Allow ICMP traffic for path discovery to worker nodes",
      destination      = local.workers-subnet,
      destination_type = "CIDR_BLOCK",
      protocol         = local.icmp_protocol,
      port             = -1,
      stateless        = false
    },
  ]

  public_lb_allowed_cidrs           = var.public_lb_allowed_cidrs
  public_lb_allowed_cidrs_and_ports = setproduct(local.public_lb_allowed_cidrs, var.public_lb_allowed_ports)

}
