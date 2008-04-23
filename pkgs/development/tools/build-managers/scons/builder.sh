source $stdenv/setup

buildPhase() {
    true
}

installPhase() {
    python setup.py install --prefix=$out
}

genericBuild
