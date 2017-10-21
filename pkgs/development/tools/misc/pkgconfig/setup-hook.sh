addPkgConfigPath () {
    addToSearchPath PKG_CONFIG_PATH $1/lib/pkgconfig
    addToSearchPath PKG_CONFIG_PATH $1/share/pkgconfig
}

if test -n "$crossConfig"; then
    crossEnvHooks+=(addPkgConfigPath)
else
    envHooks+=(addPkgConfigPath)
fi
