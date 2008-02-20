addPkgConfigPath () {
    addToSearchPath PKG_CONFIG_PATH /lib/pkgconfig "" $1
}

envHooks=(${envHooks[@]} addPkgConfigPath)
