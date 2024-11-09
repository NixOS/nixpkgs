# Darwin’s dynamic libiconv reexports libcharset, so reproduce that in static builds.
if [ -z "${dontAddExtraLibs-}" ]; then
    getHostRole
    export NIX_LDFLAGS${role_post}+=" -lcharset"
fi
