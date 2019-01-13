unpackCmdHooks+=(_tryDpkgDeb)
_tryDpkgDeb() {
    if ! [[ "$curSrc" =~ \.deb$ ]]; then return 1; fi
    dpkg-deb -x $curSrc .
}
