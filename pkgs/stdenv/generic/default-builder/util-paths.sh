######################################################################
# paths handling utilities

# Utility function: return the base name of the given path,
# with the prefix `HASH-' removed, if present.
stripHash() {
    strippedName=$(basename $1);
    if echo "$strippedName" | grep -q '^[a-z0-9]\{32\}-'; then
        strippedName=$(echo "$strippedName" | cut -c34-)
    fi
}


addToSearchPathWithCustomDelimiter() {
    local delimiter=$1
    local varName=$2
    local dir=$3
    if [ -d "$dir" ]; then
        eval export ${varName}=${!varName}${!varName:+$delimiter}${dir}
    fi
}

addToSearchPath() {
    addToSearchPathWithCustomDelimiter "${PATH_DELIMITER:-:}" "$@"
}


ensureDir() {
    echo "warning: ‘ensureDir’ is deprecated; use ‘mkdir’ instead" >&2
    local dir
    for dir in "$@"; do
        if ! [ -x "$dir" ]; then mkdir -p "$dir"; fi
    done
}

# Add $1/lib* into rpaths.
# The function is used in multiple-outputs.sh hook,
# so it is defined here but tried after the hook.
addRpathPrefix() {
    if [ "$NIX_NO_SELF_RPATH" != 1 ]; then
        export NIX_LDFLAGS="-rpath $1/lib $NIX_LDFLAGS"
        if [ -n "$NIX_LIB64_IN_SELF_RPATH" ]; then
            export NIX_LDFLAGS="-rpath $1/lib64 $NIX_LDFLAGS"
        fi
        if [ -n "$NIX_LIB32_IN_SELF_RPATH" ]; then
            export NIX_LDFLAGS="-rpath $1/lib32 $NIX_LDFLAGS"
        fi
    fi
}

