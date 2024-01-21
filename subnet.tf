# Copyright (c) 2022 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  #general defaults
  compartment_id       = try(data.oci_identity_compartments.compartment[0].compartments[0].id, var.compartment_id)
  vcn_id               = try(data.oci_core_vcns.vcns[0].virtual_networks[0].id, var.vcn_id)
  dhcp_default_options = data.oci_core_dhcp_options.dhcp_options.options.0.id
  default_freeform_tags = {
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-oci-network-subnet"
  }
  merged_freeform_tags = merge(var.freeform_tags, local.default_freeform_tags)
}

resource "oci_core_subnet" "vcn_subnet" {

  #Required
  cidr_block     = var.cidr_block
  compartment_id = local.compartment_id
  vcn_id         = local.vcn_id


  defined_tags               = var.defined_tags
  dhcp_options_id            = local.dhcp_default_options
  display_name               = var.display_name
  dns_label                  = var.dns_label
  freeform_tags              = local.merged_freeform_tags
  prohibit_public_ip_on_vnic = var.type == "public" ? false : true
  security_list_ids          = var.security_list_ids
}