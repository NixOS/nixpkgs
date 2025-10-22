unpackCmdHooks+=(_try7zip _tryCrx)
_try7zip() {
    if ! [[ "$curSrc" =~ \.7z$ ]]; then return 1; fi
    7z x "$curSrc"
}
_tryCrx(){
    if ! [[ "$curSrc" =~ \.crx$ ]]; then return 1; fi
    7z x "$curSrc"
}
