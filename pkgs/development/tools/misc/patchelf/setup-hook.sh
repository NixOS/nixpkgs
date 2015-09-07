# This setup hook calls patchelf to automatically remove unneeded
# directories from the RPATH of every library or executable in every
# output.

fixupOutputHooks+=('if [ -z "$dontPatchELF" ]; then patchELF "$prefix"; fi')

patchELF() {
    header "patching ELF executables and libraries in $prefix"
    if [ -e "$prefix" ]; then
        find "$prefix" \( \
            \( -type f -a -name "*.so*" \) -o \
            \( -type f -a -perm /0100 \) \
            \) -print -exec patchelf --shrink-rpath '{}' \;
    fi
    stopNest
}
