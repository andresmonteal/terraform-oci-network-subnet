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
  description = "(Required) (Updatable) The CIDR IP address range of the subnet. The CIDR must maintain the following rules -a. The CIDR block is valid and correctly formatted. b. The new range is within one of the parent VCN ranges.Example: 10.0.1.0/24"
  type        = string
}

variable "compartment" {
  description = "compartment name where to create all resources"
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

variable "security_list_ids" {
  description = "(Optional) (Updatable) The OCIDs of the security list or lists the subnet will use"
  type        = list(any)
  default     = []
}