module "subnet" {
  source = "../"

  for_each = var.subnets

  # subnet
  tenancy_ocid = var.tenancy_ocid
  compartment  = each.value["compartment"]
  cidr_block   = each.value["cidr_block"]
  vcn_name     = each.value["vcn"]

  # optional
  display_name = each.key
  dns_label    = each.value["dns_label"]
  type         = each.value["type"]

  # tags
  freeform_tags = lookup(each.value, "freeform_tags", {})
  defined_tags  = lookup(each.value, "defined_tags", {})

  # route table
  route_table = lookup(each.value, "route_table", null)
}