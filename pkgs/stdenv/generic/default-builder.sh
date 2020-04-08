if [ -e .attrs.sh ]; then
    . .attrs.sh
fi

source $stdenv/setup
genericBuild
