variable "description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = "KMS key for encrypting application data"
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource."
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled."
  type        = bool
  default     = true
}

variable "alias" {
  description = "The display name of the alias. The name must start with the word 'alias/' followed by a name, e.g. 'alias/my-key'. The module automatically adds 'alias/' prefix."
  type        = string
}

variable "key_policy" {
  description = "A valid policy JSON document."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
