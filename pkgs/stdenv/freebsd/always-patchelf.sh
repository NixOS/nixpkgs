fixupOutputHooks+=(_FreeBSDPatchelfShrink)

_FreeBSDPatchelfShrink() {
    find $prefix -type f | xargs -n1 patchelf --shrink-rpath &>/dev/null || true
}
