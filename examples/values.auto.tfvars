tenancy_ocid = "tenant-id"

subnets = {
  "SUBNATE-NAME" = {
    compartment  = "cmp-networking"
    vcn          = "vcn-ash-app-np"
    cidr_block   = "172.31.0.1/27"
    dns_label    = "ash-dns-test"
    type         = "private"
    defined_tags = {}
    route_table  = {}
  }
}
