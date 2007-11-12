addPkgConfigPath () {
    if test -d $1/lib/pkgconfig; then
        export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}${PKG_CONFIG_PATH:+:}$1/lib/pkgconfig"
    fi
}

envHooks=(${envHooks[@]} addPkgConfigPath)
