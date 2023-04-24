subnets = {
  "SUBNATE-NAME" = {
    network_cmp   = "NETWORKING"
    vcn           = "VCN-NAME"
    cidr_block    = "100.69.2.128/27"
    dns_label     = "ash-dns-test"
    type          = "private"
    security_list = "SECURITY-LIST-NAME"
    defined_tags  = { "NAMESPACE.TAG" = "VALUE", "NAMESPACE.TAG" = "VALUE-2" }
    route_table = {
      "ROUTE-TABLE-NAME" = {
        rules = {
          drg_rules = [{
            drg_name    = "DRG-NAME"
            destination = "0.0.0.0/0"
            description = "all addresses to drg"
            }
          ],
          sg_rules = [{
            sg_name     = "SERVICE-GATEWAY-NAME"
            description = "all addresses to svg"
            }
          ]
        }
      }
    }
  },
  "SUBNATE-NAME-2" = {
    network_cmp   = "NETWORKING"
    vcn           = "VCN-NAME"
    cidr_block    = "100.01.2.128/27"
    dns_label     = "ash-dns-test"
    type          = "private"
    security_list = "SECURITY-LIST-NAME"
    defined_tags  = { "NAMESPACE.TAG" = "VALUE", "NAMESPACE.TAG" = "VALUE-2" }
    route_table = {
      "ROUTE-TABLE-NAME-2" = {
        rules = {
          drg_rules = [{
            drg_name    = "DRG-NAME"
            destination = "0.0.0.0/0"
            description = "all addresses to drg"
            }
          ],
          sg_rules = [{
            sg_name     = "SERVICE-GATEWAY-NAME"
            description = "all addresses to svg"
            }
          ]
        }
      }
    }
  }
}