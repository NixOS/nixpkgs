addAclocals () {
    appendToSearchPathWithCustomDelimiter : ACLOCAL_PATH $1/share/aclocal
}

envHooks+=(addAclocals)
