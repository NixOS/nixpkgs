# This setup hook calls patchelf to automatically remove unneeded
# directories from the RPATH of every library or executable in every
# output.

fixupOutputHooks+=('if [ -z "$dontPatchELF" ]; then patchELF "$prefix"; fi')

patchELF() {
    header "shrinking RPATHs of ELF executables and libraries in $prefix"

    local i
    while IFS= read -r -d $'\0' i; do
        if [[ "$i" =~ .build-id ]]; then continue; fi
        if ! isELF "$i"; then continue; fi
        echo "shrinking $i"
        patchelf --shrink-rpath "$i" || true
    done < <(find "$prefix" -type f -print0)

    stopNest
}
