variable "pjt_name" {
    type = string
    default = "snowflake_practice"
}

variable "snowflake_password" {
  description = "Password for Snowflake provider"
  type        = string
  sensitive   = true
}

variable "roles_name_descript_dict" {
    type        = map(string)
    default = {
      "func_role_div_developer"="Functional Role 開発本部"
      "func_role_div_analyst"="Functional Role 分析本部"
      "func_role_div_consultant"="Functional Role コンサル本部"
      "access_role_schema_a_RW"="Access Role スキーマA RreadWrite"
      "access_role_schema_a_R"="Access Role スキーマA RreadOnly"
    }
}