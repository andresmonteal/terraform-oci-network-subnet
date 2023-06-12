tenancy_ocid = "tenant-id"
subnets = {
  sn-app-np-pri = {
    compartment  = "cmp-networking"
    vcn          = "vcn-ash-app-np"
    cidr_block   = "172.31.0.0/28"
    dns_label    = "apppri"
    type         = "private"
    defined_tags = {}
    route_table = {
      "rt-db-np-pri" = {
        rules = {
          ng_rules = [{
            ng_name     = "nat-gateway"
            description = "all addresses to nat gateway"
            destination = "0.0.0.0/0"
          }]
        }
      }
    }
  }
  sn-db-np-pri = {
    compartment  = "cmp-networking"
    vcn          = "vcn-ash-app-np"
    cidr_block   = "172.31.0.32/28"
    dns_label    = "dbpri"
    type         = "private"
    defined_tags = {}
    route_table  = {}
  }
}