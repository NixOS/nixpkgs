unpackCmdHooks+=(_trySourceRock)
unpackCmdHooks+=(_tryRockSpec)

_tryRockSpec() {
    if ! [[ "$curSrc" =~ \.rockspec$ ]]; then return 1; fi
    # prevent failure in cmdUnpack
    # the export is a hackish way to do it
    export ROCKSPEC_FILENAME="$curSrc"
    echo "Exporting ROCKSPEC_FILENAME to ''${ROCKSPEC_FILENAME}"
}

_trySourceRock() {

    if ! [[ "$curSrc" =~ \.src.rock$ ]]; then return 1; fi

    export PATH=${unzip}/bin:$PATH

    # luarocks expects a clean <name>.rock.spec name to be the package name
    # so we have to strip the hash
    renamed="$(stripHash $curSrc)"
    cp -v "$curSrc" "$renamed"
    luarocks unpack --force "$renamed"
}

