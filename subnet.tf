# Copyright (c) 2022 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  dhcp_default_options = data.oci_core_dhcp_options.dhcp_options.options.0.id
  defined_tags         = data.oci_core_vcns.vcns.virtual_networks[0].defined_tags
  vcn_id               = data.oci_core_vcns.vcns.virtual_networks[0].id
  security_list_ids    = [data.oci_core_security_lists.sec_lists.security_lists[0].id]
  default_freeform_tags = {
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-oci-network-subnet"
  }
  merged_freeform_tags = merge(var.freeform_tags, local.default_freeform_tags)
}

resource "oci_core_subnet" "vcn_subnet" {

  #Required
  cidr_block     = var.cidr_block
  compartment_id = var.compartment_id
  vcn_id         = local.vcn_id


  defined_tags               = var.defined_tags == null ? local.defined_tags : var.defined_tags
  dhcp_options_id            = local.dhcp_default_options
  display_name               = var.display_name
  dns_label                  = var.dns_label
  freeform_tags              = local.merged_freeform_tags
  prohibit_public_ip_on_vnic = var.type == "public" ? false : true
  security_list_ids          = local.security_list_ids

}

module "route_table" {
  source   = "git::ssh://devops.scmservice.us-ashburn-1.oci.oraclecloud.com/namespaces/id9de6bj2yv6/projects/claro-devops/repositories/terraform-oci-route-table?ref=v0.3.3"
  for_each = var.route_table

  display_name   = each.key
  compartment_id = var.compartment_id
  subnet_ids     = [oci_core_subnet.vcn_subnet.id]
  vcn_id         = local.vcn_id
  defined_tags   = var.defined_tags == null ? local.defined_tags : var.defined_tags
  freeform_tags  = local.merged_freeform_tags

  rules = can(each.value["rules"]) ? each.value["rules"] : {}
}