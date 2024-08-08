locals {
    filtered_map_access_role = {for key,val in var.roles_name_descript_dict : key=>val if startswith(key, "access_role_")}
    filtered_map_functional_role = {for key,val in var.roles_name_descript_dict : key=>val if startswith(key, "func_role_")}
    
    read_write_keys = [for k in keys(var.roles_name_descript_dict) : k if can(regex("_RW", k))][0]
    read_keys = [for k in keys(var.roles_name_descript_dict) : k if can(regex("_R", k))][0]

    # Access role を Functional role に grant する
    # develop: RW, analyst: R, consul: R
    combine_functional_and_access_role = {
        for key in keys(var.roles_name_descript_dict) :
        key => (
            key == "func_role_div_developer" ? local.read_write_keys:
            key == "func_role_div_analyst" ? local.read_keys:
            key == "func_role_div_consultant" ? local.read_keys:
            null
        )
        if can(regex("func_role_div_", key))
    }
}

resource "snowflake_role_grants" "access_role_to_functional_role_grants" {
    provider = snowflake.securityadmin
    for_each = {for k,v in local.combine_functional_and_access_role: k=>v}

    # access roleを
    role_name = each.value
    # functional roleにぶらさげる
    roles     = [each.key]
}

#output "combined_map" {
#  value = local.combine_functional_and_access_role
#}
