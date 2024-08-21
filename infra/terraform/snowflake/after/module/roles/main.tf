# Roleを作成
# ToDo：今後 作成するRoleをYMLで管理しForLoopで一挙に作成する

resource "snowflake_role" "roles" {
    provider = snowflake.securityadmin
    for_each = {
        for role in concat(var.access_roles, var.functional_roles):
            role.name => role.comment
    }
    name = each.key
    comment = each.value
}


# SYSADMIN にぶら下げる(sysadminにusage権限がつく)
# func role をsysadminにぶらさげるだけでよさそう　202407147
resource "snowflake_role_grants" "role_grants" {
    provider = snowflake.securityadmin
    for_each = toset([for role in var.functional_roles:role.name])
    role_name = each.key
    roles     = ["SYSADMIN"]
}
