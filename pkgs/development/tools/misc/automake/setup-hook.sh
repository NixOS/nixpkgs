addAclocals () {
    addToSearchPathWithCustomDelimiter : ACLOCAL_PATH $1/share/aclocal
}

envHooks=(${envHooks[@]} addAclocals)
