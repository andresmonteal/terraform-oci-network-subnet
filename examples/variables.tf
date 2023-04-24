
# Copyright (c) 2019, 2021, Oracle Corporation and/or affiliates.

variable "tenancy_ocid" {
  description = "root compartment"
  default     = "tenancy-id"
}

# general oci parameters

variable "network_cmp" {
  description = "compartment ocid where vcn and subnet are located"
  type        = string
  default     = "NETWORKING"
}

# subnet parameters

variable "subnets" {
  type = map(any)
}