addAclocals () {
    if test -d $1/share/aclocal; then
        export ACLOCAL_PATH="$ACLOCAL_PATH${ACLOCAL_PATH:+:}$1/share/aclocal"
    fi
}

envHooks=(${envHooks[@]} addAclocals)
