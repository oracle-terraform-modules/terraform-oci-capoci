# Copyright 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "subnet_ids" {
  value = {
    "cp"      = join(",", oci_core_subnet.cp[*].id)
    "workers" = join(",", oci_core_subnet.workers[*].id)
    "int_lb"  = join(",", oci_core_subnet.int_lb[*].id)
    "pub_lb"  = join(",", oci_core_subnet.pub_lb[*].id)
  }
}