# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_compartments" "compartment" {
  count = var.tenancy_ocid == null ? 0 : 1
  #Required
  compartment_id            = var.tenancy_ocid
  access_level              = "ANY"
  compartment_id_in_subtree = true

  #Optional
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }

  filter {
    name   = "name"
    values = [var.compartment]
  }
}

data "oci_core_vcns" "vcns" {
  count = var.vcn_name == null ? 0 : 1
  compartment_id = local.compartment_id
  display_name   = var.vcn_name

  depends_on = [data.oci_identity_compartments.compartment]
}

data "oci_core_dhcp_options" "dhcp_options" {
  compartment_id = local.compartment_id
  vcn_id         = local.vcn_id
  depends_on     = [data.oci_core_vcns.vcns]
}