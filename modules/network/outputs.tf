# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "subnet_ids" {
  value = {
    "cp"                    = join(",", oci_core_subnet.cp[*].id)
    "cp-endpoint"           = join(",", oci_core_subnet.cp-endpoint[*].id)
    "workers"               = join(",", oci_core_subnet.workers[*].id)
    "service-lb-int-subnet" = join(",", oci_core_subnet.service-lb-int-subnet[*].id)
    "service-lb-pub-subnet" = join(",", oci_core_subnet.service-lb-pub-subnet[*].id)
  }
}
