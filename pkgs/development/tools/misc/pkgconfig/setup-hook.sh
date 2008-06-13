addPkgConfigPath () {
    addToSearchPath PKG_CONFIG_PATH /lib/pkgconfig "" $1
    addToSearchPath PKG_CONFIG_PATH /share/pkgconfig "" $1
}

envHooks=(${envHooks[@]} addPkgConfigPath)
