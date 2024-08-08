locals {
    filtered_map_functional_role = {for key,val in var.roles_name_descript_dict : key=>val if startswith(key, "func_role_")}
    
    functional_role_developer = [for k in keys(local.filtered_map_functional_role) : k if can(regex("_div_develope", k))]
    functional_role_cunsultant = [for k in keys(local.filtered_map_functional_role) : k if can(regex("_div_consultant", k))]
}

# user1に紐づけるFunctionalRoleを定義
resource "snowflake_role_grants" "access_role_to_functional_role_grants" {
    provider = snowflake.securityadmin
    for_each = toset([for k in local.functional_role_developer: k])

    role_name = each.key
    users     = ["${var.pjt_name}_user1"]
}

# user2に紐づけるFunctionalRoleを定義
resource "snowflake_role_grants" "access_role_to_functional_role_grants2" {
    provider = snowflake.securityadmin
    for_each = toset([for k in local.functional_role_cunsultant: k])

    role_name = each.key
    users     = ["${var.pjt_name}_user2"]
}

#output "toset" {
#    value = toset([for k in local.functional_role_developer: k])
#}


