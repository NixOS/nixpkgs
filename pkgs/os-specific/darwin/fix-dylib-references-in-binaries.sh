# A setup-hook for Darwin that acts like auto patchelf: for any executable in
# $out/bin, for any dynamic libraries it depends on which don’t have a full
# path, this hook looks for those libraries in all this package’s dependencies
# (and in this package’s own lib folder).

# First, for every dependency that has a /lib/ dir, put it in a search path.
fixDarwinDylibReferencesHook() {
    addToSearchPath FIX_DYNLIB_PATH "$1/lib"
}
addEnvHooks "$targetOffset" fixDarwinDylibReferencesHook

# After which, in a fixup phase, find every binary and search that path for
# unresolved libraries.
fixupOutputHooks+=('fixDarwinDylibReferences')

fixDarwinDylibReferencesBin() {
    bin="$1"
    # “Handle” errors by just bailing on this file, which is equivalent to
    # iterating over empty output, because this tool prints errors on stderr not
    # stdout.
    (otool -L "$bin" 2>/dev/null | tail -n +2 || true) | while read libpath rest ; do
        if [[ "$libpath" != /* ]]; then
            # This is not an absolute path: try to find it in our
            # dependencies
            libname="$(basename "$libpath")"
            # How to handle $lib?
            IFS=: read -a dirs <<<"$out/lib:$FIX_DYNLIB_PATH"
            for dir in "${dirs[@]}"; do
                # Only check for the raw lib name because the path is
                # usually just some build-dependent cruft. We are looking
                # for libs directly here.
                if [[ -f "$dir/$libname" ]]; then
                    install_name_tool -change "$libpath" "$dir/$libname" "$bin"
                    break
                fi
            done
        fi
    done
}

fixDarwinDylibReferences() {
    if [[ -d "$prefix/bin" ]]; then
        find "$prefix/bin" -type f -executable -print0 | while IFS= read -r -d $'\0' bin; do
            fixDarwinDylibReferencesBin "$bin"
        done
    fi
}
