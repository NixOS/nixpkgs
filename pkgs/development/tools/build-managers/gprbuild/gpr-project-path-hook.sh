addAdaObjectsPath() {
    local role_post
    getHostRoleEnvHook

    addToSearchPath "GPR_PROJECT_PATH${role_post}" "$1/share/gpr"
}

addEnvHooks "$targetOffset" addAdaObjectsPath

fixDarwinRpath() {
    for f in $(find $out -type f -executable); do
        install_name_tool -id $f $f || true
        for rpath in $(otool -L $f | grep rpath | awk '{print $1}'); do
            install_name_tool -change $rpath $out/lib/$(basename $rpath) $f || true
        done
    done
}

if [ "$(uname)" = "Darwin" ]; then
    preFixupPhases+=" fixDarwinRpath"
fi
