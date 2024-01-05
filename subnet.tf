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

module "security_lists" {
  source = "git@github.com:andresmonteal/terraform-oci-network-sec-list.git?ref=v0.3.6"

  compartment_id             = local.compartment_id
  vcn_id                     = local.vcn_id
  default_security_list_name = var.default_security_list_name

  security_lists = var.security_lists
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
  security_list_ids          = [for _, item in module.security_lists.id : item.id]

  depends_on = [module.security_lists]
}

module "route_table" {
  source   = "git@github.com:andresmonteal/terraform-oci-route-table.git?ref=v0.5.4"

  for_each = var.route_table

  display_name   = each.key
  compartment_id = local.compartment_id
  subnet_ids     = [oci_core_subnet.vcn_subnet.id]
  vcn_id         = local.vcn_id
  defined_tags   = var.defined_tags
  freeform_tags  = local.merged_freeform_tags

  rules = can(each.value["rules"]) ? each.value["rules"] : {}
}