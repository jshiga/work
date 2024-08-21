module "user" {
  source = "./module/users/"
  pjt_name = var.pjt_name
  snowflake_password= var.snowflake_password
}


module "roles" {
  source = "./module/roles/"
  snowflake_password= var.snowflake_password
  access_roles = local.access_roles
  functional_roles = local.functional_roles
}


module "grant_access_role" {
  source = "./module/grant_access_role/"
  snowflake_password= var.snowflake_password
  grant_on_object_to_access_role=local.grant_on_object_to_access_role
}


module "grant_functional_role" {
  source = "./module/grant_functional_role/"
  snowflake_password= var.snowflake_password
  grant_access_role_to_functional_role=local.grant_access_role_to_functional_role
}


module "grant_functional_role_to_user" {
  source = "./module/grant_functional_role_to_user/"
  snowflake_password= var.snowflake_password
  grant_functional_roles_to_user = local.grant_functional_roles_to_user
}
