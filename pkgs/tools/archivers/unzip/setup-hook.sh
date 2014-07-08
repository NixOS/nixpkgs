unpackCmdHooks+=(_tryUnzip)
_tryUnzip() {
    if ! [[ "foo.zip" =~ \.zip$ ]]; then return 1; fi
    unzip -qq "$curSrc"
}
