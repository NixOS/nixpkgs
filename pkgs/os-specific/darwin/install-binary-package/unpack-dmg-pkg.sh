# shellcheck shell=bash
unpackCmdHooks+=(unpackDmgPkg)
unpackDmgPkg() {
    case "$curSrc" in
        *.dmg) unpackDmg "$curSrc";;
        *.pkg) unpackPkg "$curSrc";;
        *) return 1
    esac
}

unpackDmg() {
    _unpack "$1" "${2:-$pname}"
}

unpackPkg() {
    _unpack "$1" "${2:-$pname}"
    pushd "${2:-$pname}"
    # Extract files from Payload or Payload~ file contained in given pkg if any
    # Depending on how apps are packaged maxdepth might need to be adjusted
    # or made adjustable
    find . -name 'Payload*' -maxdepth 2 -print0 | xargs -0 -t -I % bsdtar -xf %
    popd
}

_unpack() {
    # Exclude */Applications files from extraction as they may
    # contain a dangerous link path, causing 7zz to error.
    # Exclude *com.apple.provenance xattr files from extraction as they
    # break the an application's signature and notarization.
    7zz x -bd -o"$2" -xr'!*/Applications' -xr'!*com.apple.provenance' "$1"
}
