variable "table_name" {
  description = "Name of the DynamoDB table. Must be unique."
  type        = string
}

variable "tags" {
  description = "Tags to set on the table."
  type        = map(string)
  default     = {}
}

variable "read_capacity" {
  type    = number
  default = 1
}

variable "write_capacity" {
  type    = number
  default = 1
}
