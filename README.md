# OCI Subnet Terraform Module

This Terraform module provisions Subnets in Oracle Cloud Infrastructure (OCI).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Files](#files)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) 0.12 or later
- Oracle Cloud Infrastructure account credentials

## Usage

To use this module, include the following code in your Terraform configuration:

```hcl
module "oci_subnet" {
  source = "path_to_this_module"

  # Define the necessary variables
  tenancy_ocid    = var.tenancy_ocid
  compartment_id  = var.compartment_id
  compartment     = var.compartment
  cidr_block      = var.cidr_block
  vcn_id          = var.vcn_id
  vcn_name        = var.vcn_name
  defined_tags    = var.defined_tags
  display_name    = var.display_name
  dns_label       = var.dns_label
  type            = var.type
  freeform_tags   = var.freeform_tags
  security_list_ids = var.security_list_ids
}
```

## Files

- `variables.tf`: Defines input variables.
- `main.tf`: Main Terraform configuration for setting up the subnet.
- `output.tf`: Defines output values to be exported.
- `datasources.tf`: Configuration for data sources to be used in the module.

### main.tf

```hcl
locals {
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
```

### variables.tf

```hcl
# required
variable "tenancy_ocid" {
  description = "(Required) (Updatable) The OCID of the root compartment."
  type        = string
  default     = null
}

variable "compartment_id" {
  description = "(Required) (Updatable) The OCID of the compartment to contain the subnet."
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "(Required) (Updatable) The CIDR IP address range of the subnet. The CIDR must maintain the following rules: a. The CIDR block is valid and correctly formatted. b. The new range is within one of the parent VCN ranges. Example: 10.0.1.0/24"
  type        = string
}

variable "compartment" {
  description = "Compartment name where to create all resources."
  type        = string
  default     = null
}

variable "vcn_id" {
  type        = string
  description = "The VCN ID where the Security List(s) should be created."
  default     = null
}

variable "vcn_name" {
  type        = string
  description = "The VCN name where the Security List(s) should be created."
  default     = null
}

# optional

variable "defined_tags" {
  description = "(Optional) (Updatable) Defined tags for this resource. Each key is predefined and scoped to a namespace. For more information, see Resource Tags."
  type        = map(string)
  default     = null
}

variable "display_name" {
  description = "(Optional) (Updatable) A user-friendly name. Does not have to be unique, and it's changeable. Avoid entering confidential information."
  type        = string
  default     = null
}

variable "dns_label" {
  description = "(Optional) A DNS label for the subnet, used in conjunction with the VNIC's hostname and VCN's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet."
  type        = string
  default     = null
}

variable "type" {
  description = "(Optional) Type of subnet: public | private."
  type        = string
  default     = "private"
}

variable "freeform_tags" {
  description = "Simple key-value pairs to tag the created resources using freeform OCI Free-form tags."
  type        = map(any)
  default     = {}
}

variable "security_list_ids" {
  description = "(Optional) (Updatable) The OCIDs of the security list or lists the subnet will use."
  type        = list(any)
  default     = []
}
```

### output.tf

```hcl
output "all_attributes" {
  value = { for k, v in oci_core_subnet.vcn_subnet : k => v }
}
```

### datasources.tf

```hcl
data "oci_identity_compartments" "compartment" {
  count = var.tenancy_ocid == null ? 0 : 1
  #Required
  compartment_id            = var.tenancy_ocid
  access_level              = "ANY"
  compartment_id_in_subtree = true

  #Optional
  filter {
    name   = "state"
    values = ["ACTIVE"]
  }

  filter {
    name   = "name"
    values = [var.compartment]
  }
}

data "oci_core_vcns" "vcns" {
  count          = var.vcn_name == null ? 0 : 1
  compartment_id = local.compartment_id
  display_name   = var.vcn_name

  depends_on = [data.oci_identity_compartments.compartment]
}

data "oci_core_dhcp_options" "dhcp_options" {
  compartment_id = local.compartment_id
  vcn_id         = local.vcn_id
  depends_on     = [data.oci_core_vcns.vcns]
}
```

## Inputs

| Name             | Description                                                                                                   | Type       | Default | Required |
|------------------|---------------------------------------------------------------------------------------------------------------|------------|---------|----------|
| tenancy_ocid     | (Required) (Updatable) The OCID of the root compartment.                                                      | `string`   | `null`  | yes      |
| compartment_id   | (Required) (Updatable) The OCID of the compartment to contain the subnet.                                     | `string`   | `null`  | yes      |
| cidr_block       | (Required) (Updatable) The CIDR IP address range of the subnet. Example: 10.0.1.0/24.                         | `string`   | `null`  | yes      |
| compartment      | Compartment name where to create all resources.                                                               | `string`   | `null`  | yes      |
| vcn_id           | The VCN ID where the Security List(s) should be created.                                                      | `string`   | `null`  | yes      |
| vcn_name         | The VCN name where the Security List(s) should be created.                                                    | `string`   | `null`  | yes      |
| defined_tags     | (Optional) (Updatable) Defined tags for this resource.                                                        | `map(string)` | `null`  | no       |
| display_name     | (Optional) (Updatable) A user-friendly name.                                                                  | `string`   | `null`  | no       |
| dns_label        | (Optional) A DNS label for the subnet.                                                                        | `string`   | `null`  | no       |
| type             | (Optional) Type of subnet: public | private.                                                                  | `string`   | `"private"` | no       |
| freeform_tags    | Simple key-value pairs to tag the created resources using freeform OCI Free-form tags.                        | `map(any)` | `{}`    | no       |
| security_list_ids| (Optional) (Updatable) The OCIDs of the security list or lists the subnet will use.                           | `list(any)`| `[]`    | no       |

## Outputs

| Name            | Description                            |
|-----------------|----------------------------------------|
| all_attributes  | All attributes of the created subnet.  |

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any bugs, feature requests, or enhancements.

## License

This project is licensed under the Universal Permissive License v 1.0. See the [LICENSE](https://oss.oracle.com/licenses/upl) file for details.