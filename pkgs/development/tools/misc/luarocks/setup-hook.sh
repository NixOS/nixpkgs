unpackCmdHooks+=(_trySourceRock)
unpackCmdHooks+=(_tryRockSpec)

_tryRockSpec() {
    if ! [[ "$curSrc" =~ \.rockspec$ ]]; then return 1; fi
}

_trySourceRock() {

    if ! [[ "$curSrc" =~ \.src.rock$ ]]; then return 1; fi

    export PATH=${unzip}/bin:$PATH

    # luarocks expects a clean <name>.rock.spec name to be the package name
    # so we have to strip the hash
    renamed="$(stripHash $curSrc)"
    cp "$curSrc" "$renamed"
    luarocks unpack --force "$renamed"
}

