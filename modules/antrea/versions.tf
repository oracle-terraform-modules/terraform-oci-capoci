# Copyright (c) 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      # pass oci home region provider explicitly for identity operations
      version               = ">= 4.67.3"
    }
  }
  required_version = ">= 1.0.0"
}