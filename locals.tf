# Copyright 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {

  vcn_id       = var.create_vcn == true ? module.vcn[0].vcn_id : coalesce(var.vcn_id, data.oci_core_vcns.vcns[0].virtual_networks[0].id)
  ig_route_id  = var.create_vcn == true ? module.vcn[0].ig_route_id : coalesce(var.ig_route_table_id, data.oci_core_route_tables.ig[0].route_tables[0].id)
  nat_route_id = var.create_vcn == true ? module.vcn[0].nat_route_id : coalesce(var.nat_route_table_id, data.oci_core_route_tables.nat[0].route_tables[0].id)

  validate_drg_input = var.create_drg && (var.drg_id != null) ? tobool("[ERROR]: create_drg variable can not be true if drg_id is provided.]") : true
}
