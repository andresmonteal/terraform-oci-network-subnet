output "all_attributes" {
  value = { for k, v in oci_core_subnet.vcn_subnet : k => v }
}
