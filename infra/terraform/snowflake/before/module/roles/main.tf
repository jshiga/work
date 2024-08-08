# Roleを作成
resource "snowflake_role" "roles" {
    provider = snowflake.securityadmin
    for_each = var.roles_name_descript_dict
    name = each.key
    comment = each.value
}

# SYSADMIN にぶら下げる(sysadminにusage権限がつく)
# func role をsysadminにぶらさげる
resource "snowflake_role_grants" "role_grants" {
    provider = snowflake.securityadmin
    for_each = toset([for role in snowflake_role.roles : role.name if can(regex("func_role_", role.name))])
    role_name = each.key
    roles     = ["SYSADMIN"]
}