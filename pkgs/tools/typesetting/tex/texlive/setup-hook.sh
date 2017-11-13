addTeXMFPath () {
    prependToSearchPath TEXINPUTS "$1/share/texmf-nix"
}

envHooks+=(addTeXMFPath)
