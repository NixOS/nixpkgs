ccWrapper_blocklistCVars () {
    local role_post
    getHostRoleEnvHook

    local vn
    vn=NIX_CFLAGS_COMPILE${role_post}
    eval "export ${vn}=\"\$(@gnused@/bin/sed 's_ -isystem[[:space:]]*[^[:space:]]*fbworld-dev/include__g' <<<\$${vn})\""
}
addEnvHooks "$targetOffset" ccWrapper_blocklistCVars
