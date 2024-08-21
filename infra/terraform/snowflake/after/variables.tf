variable "pjt_name" {
    type = string
    default = "snowflake_practice"
}
variable "snowflake_password" {
  description = "Password for Snowflake provider"
  type        = string
  sensitive   = true
}