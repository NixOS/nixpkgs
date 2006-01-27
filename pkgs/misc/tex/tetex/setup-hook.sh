addTeXMFPath () {
    if test -d "$1/share/texmf-nix"; then
        export TEXMFNIX="${TEXMFNIX}${TEXMFNIX:+:}$1/share/texmf-nix"
    fi
}

envHooks=(${envHooks[@]} addTeXMFPath)
