variable "domain_name" {
  description = "Primary domain name"
  type        = list(any)
  default     = ["wayofthesys.org"]
}

variable "region" {
  description = "Primary region"
  type        = string
  default     = "us-east-2"
}
