# Copyright (c) 2022 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# required

variable "compartment_id" {
  description = "(Required) (Updatable) The OCID of the compartment to contain the subnet."
  type        = string
}

variable "cidr_block" {
  description = "(Required) (Updatable) The CIDR IP address range of the subnet. The CIDR must maintain the following rules -a. The CIDR block is valid and correctly formatted. b. The new range is within one of the parent VCN ranges.Example: 10.0.1.0/24"
  type        = string
}

variable "vcn_name" {
  description = "(Required) The VCN name to contain the subnet."
  type        = string
}


# optional

variable "defined_tags" {
  description = "Optional) (Updatable) Defined tags for this resource. Each key is predefined and scoped to a namespace. For more information, see Resource Tags"
  type        = map(string)
  default     = null
}

variable "display_name" {
  description = "(Optional) (Updatable) A user-friendly name. Does not have to be unique, and it's changeable. Avoid entering confidential information."
  type        = string
  default     = null
}

variable "dns_label" {
  description = "(Optional) A DNS label for the subnet, used in conjunction with the VNIC's hostname and VCN's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet"
  type        = string
  default     = null
}

variable "type" {
  description = "(Optional) type of subnet: public | private"
  type        = string
  default     = "private"
}

variable "freeform_tags" {
  description = "simple key-value pairs to tag the created resources using freeform OCI Free-form tags."
  type        = map(any)
  default     = {}
}

variable "sec_ls_disp_name" {
  description = "A user-friendly name. Does not have to be unique, and it's changeable"
  type        = string
  default     = null
}

# route table

variable "route_table" {
  description = "(Optional) add a route table name"
  type        = map(any)
  default     = {}
}