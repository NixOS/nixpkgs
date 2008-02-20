addAclocals () {
    addToSearchPathWithCustomDelimiter : ACLOCAL_PATH /share/aclocal "" $1
}

envHooks=(${envHooks[@]} addAclocals)
