gettextDataDirsHook() {
    # See pkgs/build-support/setup-hooks/role.bash
    getHostRoleEnvHook
    if [ -d "$1/share/gettext" ]; then
        addToSearchPath "GETTEXTDATADIRS${role_post}" "$1/share/gettext"
    fi
}

addEnvHooks "$hostOffset" gettextDataDirsHook
