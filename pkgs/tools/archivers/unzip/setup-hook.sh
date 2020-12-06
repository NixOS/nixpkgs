unpackCmdHooks+=(_tryUnzip)
_tryUnzip() {
    if ! [[ "$curSrc" =~ \.zip$ ]]; then return 1; fi
    unzip -qq "$curSrc"
}
