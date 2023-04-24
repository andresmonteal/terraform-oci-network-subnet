module "subnet" {
  source = "git::ssh://devops.scmservice.us-ashburn-1.oci.oraclecloud.com/namespaces/id9de6bj2yv6/projects/claro-devops/repositories/terraform-oci-network-subnet?ref=v0.1.10"

  for_each = var.subnets

  # subnet
  compartment_id = data.oci_identity_compartments.network_cmp[each.key].compartments[0].id
  cidr_block     = each.value["cidr_block"]
  vcn_name       = each.value["vcn"]

  # optional
  display_name     = each.key
  dns_label        = each.value["dns_label"]
  type             = each.value["type"]
  sec_ls_disp_name = each.value["security_list"]

  # tags
  freeform_tags = lookup(each.value, "freeform_tags", {})
  defined_tags  = lookup(each.value, "defined_tags", {})

  # route table
  route_table = lookup(each.value, "route_table", null)
}