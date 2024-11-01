addC2ffiDep() {
    local role_post
    getHostRoleEnvHook

    if [ -d "$1/include" ]; then
        export NIX_C2FFI_FLAGS+=" -i $1/include"
    fi
}

getTargetRole
getTargetRoleWrapper

addEnvHooks "$targetOffset" addC2ffiDep
