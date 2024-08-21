resource "snowflake_user" "preset_user1" {
    provider = snowflake.useradmin
    name = "${var.pjt_name}_user1"
    password             = "Snowflake_1234"
    must_change_password = true
}


resource "snowflake_user" "preset_user2" {
    provider = snowflake.useradmin
    name = "${var.pjt_name}_user2"
    password             = "Snowflake_1234"
    must_change_password = true
}