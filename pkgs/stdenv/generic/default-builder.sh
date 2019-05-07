if [ -e .attrs.sh ]; then source .attrs.sh; fi

source $stdenv/setup
genericBuild
