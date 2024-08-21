resource "snowflake_role_grants" "functional_role_grants_to_user" {
    provider = snowflake.securityadmin
    for_each = {
        for grant in var.grant_functional_roles_to_user: grant.role_name => {
            role_name = grant.role_name
            users = grant.users
        }
    }
    role_name = each.value.role_name
    users     = each.value.users
}