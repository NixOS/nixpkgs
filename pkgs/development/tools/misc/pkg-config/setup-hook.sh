addPkgConfigPath () {
    addToSearchPath PKG_CONFIG_PATH $1/lib/pkgconfig
    addToSearchPath PKG_CONFIG_PATH $1/share/pkgconfig
}

addEnvHooks "$targetOffset" addPkgConfigPath
