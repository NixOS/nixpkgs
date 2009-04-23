source $stdenv/setup

flags="WXPORT=gtk2 NO_HEADERS=1 BUILD_GLCANVAS=0 BUILD_OGL=0 UNICODE=1"

configurePhase() {
    cd wxPython
}

buildPhase() {
    python setup.py $flags build
}

installPhase() {
    python setup.py $flags install --prefix=$out
}

genericBuild
