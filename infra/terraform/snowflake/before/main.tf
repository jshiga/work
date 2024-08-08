module "user" {
  source = "./module/user/"
  pjt_name = var.pjt_name
  snowflake_password= var.snowflake_password
}

module "roles" {
  source = "./module/roles/"
  snowflake_password= var.snowflake_password
  roles_name_descript_dict = var.roles_name_descript_dict
}

module "grant_access_role" {
  source = "./module/grant_access_role/"
  snowflake_password= var.snowflake_password
  roles_name_descript_dict = var.roles_name_descript_dict
}

module "grant_functional_role" {
  source = "./module/grant_functional_role/"
  snowflake_password= var.snowflake_password
  roles_name_descript_dict = var.roles_name_descript_dict
}

module "grant_functional_role_to_user" {
  source = "./module/grant_functional_role_to_user/"
  snowflake_password= var.snowflake_password
  roles_name_descript_dict = var.roles_name_descript_dict
}
