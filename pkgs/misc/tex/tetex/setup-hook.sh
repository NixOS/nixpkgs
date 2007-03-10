addTeXMFPath () {
    if test -d "$1/share/texmf-nix"; then
        export TEXINPUTS="${TEXINPUTS}${TEXINPUTS:+:}$1/share/texmf-nix//:"
    fi
}

envHooks=(${envHooks[@]} addTeXMFPath)
