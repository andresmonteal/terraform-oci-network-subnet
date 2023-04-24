data "oci_identity_compartments" "network_cmp" {

  for_each = var.subnets
  #Required
  compartment_id = var.tenancy_ocid

  #Optional
  name = each.value["network_cmp"]
}