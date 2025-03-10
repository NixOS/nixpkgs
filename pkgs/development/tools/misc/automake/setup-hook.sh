addAclocals () {
    appendToSearchPathWithCustomDelimiter : ACLOCAL_PATH $1/share/aclocal
}

addEnvHooks "$hostOffset" addAclocals
