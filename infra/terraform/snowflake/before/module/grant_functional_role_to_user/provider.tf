terraform {
   required_version = "~> 1.6.0"
   required_providers {
     snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.64.0"
     }
   }
}
provider "snowflake" {
  alias  = "securityadmin"
  role   = "SECURITYADMIN"
  password = var.snowflake_password
}