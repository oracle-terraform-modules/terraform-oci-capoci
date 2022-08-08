# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# OCI Provider parameters
variable "api_fingerprint" {
  default     = ""
  description = "Fingerprint of the API private key to use with OCI API."
  type        = string
}

variable "api_private_key" {
  default     = ""
  description = "The contents of the private key file to use with OCI API. This takes precedence over private_key_path if both are specified in the provider."
  sensitive   = true
  type        = string
}

variable "api_private_key_password" {
  default     = ""
  description = "The corresponding private key password to use with the api private key if it is encrypted."
  sensitive   = true
  type        = string
}

variable "api_private_key_path" {
  default     = ""
  description = "The path to the OCI API private key."
  type        = string
}

variable "home_region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "The tenancy's home region. Required to perform identity operations."
  type        = string
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "The OCI region where OCI resources will be created."
  type        = string
}

variable "tenancy_id" {
  description = "The tenancy id of the OCI Cloud Account in which to create the resources."
  type        = string
}

variable "user_id" {
  description = "The id of the user that terraform will use to create the resources."
  type        = string
  default     = ""
}

# General OCI parameters
variable "compartment_id" {
  description = "The compartment id where to create all resources."
  type        = string
}

variable "label_prefix" {
  default     = "none"
  description = "A string that will be prepended to all resources."
  type        = string
}

# ssh keys
variable "ssh_private_key" {
  default     = ""
  description = "The contents of the private ssh key file."
  sensitive   = true
  type        = string
}

variable "ssh_private_key_path" {
  default     = "none"
  description = "The path to ssh private key."
  type        = string
}

variable "ssh_public_key" {
  default     = ""
  description = "The contents of the ssh public key."
  type        = string
}

variable "ssh_public_key_path" {
  default     = "none"
  description = "The path to ssh public key."
  type        = string
}

# vcn parameters

variable "create_vcn" {
  type        = bool
  description = "Whether to create a Virtual Cloud Network."
  default     = true
}

variable "vcn_display_name" {
  type        = string
  description = "Existing VCN name where the resources will be created"
  default     = ""
}

variable "vcn_id" {
  type        = string
  description = "Existing VCN id where the resources will be created"
  default     = ""

}

variable "ig_route_table_display_name" {
  type        = string
  description = "Existing Internet Gateway route table name"
  default     = ""
}

variable "ig_route_table_id" {
  type        = string
  description = "Existing Internet Gateway Route table id"
  default     = ""

}

variable "nat_route_table_display_name" {
  type        = string
  description = "Existing NAT Gateway route table name"
  default     = ""
}

variable "nat_route_table_id" {
  type        = string
  description = "Existing NAT Gateway Route table id"
  default     = ""
}

variable "create_drg" {
  description = "Whether to create Dynamic Routing Gateway. If set to true, creates a Dynamic Routing Gateway and attach it to the VCN."
  type        = bool
  default     = false
}

variable "drg_display_name" {
  description = "(Updatable) Name of Dynamic Routing Gateway. Does not have to be unique."
  type        = string
  default     = "drg"
}

variable "drg_id" {
  description = "ID of an external created Dynamic Routing Gateway to be attached to the VCN"
  type        = string
  default     = null
}

variable "internet_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to Internet Gateway Route Table"
  type        = list(map(string))
  default     = null
}

variable "local_peering_gateways" {
  description = "Map of Local Peering Gateways to attach to the VCN."
  type        = map(any)
  default     = null
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  default     = true
  type        = bool
}

variable "nat_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to NAT Gateway Route Table"
  type        = list(map(string))
  default     = null
}

variable "nat_gateway_public_ip_id" {
  description = "OCID of reserved IP address for NAT gateway. The reserved public IP address needs to be manually created."
  default     = "none"
  type        = string
}

variable "subnets" {
  description = "parameters to cidrsubnet function to calculate subnet masks within the VCN."
  default = {
    bastion        = { netnum = 0, newbits = 14 }
    operator       = { netnum = 1, newbits = 14 }
    cp-endpoint    = { netnum = 1, newbits = 13 }
    cp             = { netnum = 2, newbits = 13 }
    service-lb-int = { netnum = 1, newbits = 11 }
    service-lb-pub = { netnum = 2, newbits = 11 }
    workers        = { netnum = 1, newbits = 6 }
  }
  type = map(any)
}

variable "vcn_cidrs" {
  default     = ["10.0.0.0/16"]
  description = "The list of IPv4 CIDR blocks the VCN will use."
  type        = list(string)
}

variable "vcn_dns_label" {
  default     = "capoci"
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet."
  type        = string
}

variable "vcn_name" {
  default     = "capoci"
  description = "The name of the VCN"
  type        = string
}

# control plane
variable "control_plane_type" {
  default     = "public"
  description = "Whether to allow public or private access to the control plane endpoint"
  type        = string

  validation {
    condition     = contains(["public", "private"], var.control_plane_type)
    error_message = "Accepted values are public, or private."
  }
}

# load balancers
variable "load_balancers" {
  # values: both, internal, public
  default     = "public"
  description = "The type of subnets to create for load balancers."
  type        = string
  validation {
    condition     = contains(["public", "internal", "both"], var.load_balancers)
    error_message = "Accepted values are public, internal or both."
  }
}

# workers
variable "worker_type" {
  default     = "private"
  description = "Whether to provision public or private workers."
  type        = string
  validation {
    condition     = contains(["public", "private"], var.worker_type)
    error_message = "Accepted values are public or private."
  }
}

# tagging
variable "freeform_tags" {
  default = {
    # vcn, bastion and operator tags are required
    # add more tags in each as desired
    vcn = {
      environment = "dev"
    }
  }
  description = "Tags to apply to different resources."
  type = object({
    vcn = map(any),
  })
}
