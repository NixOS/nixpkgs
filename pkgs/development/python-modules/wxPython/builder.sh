source $stdenv/setup

flags="WXPORT=gtk2 BUILD_GLCANVAS=0 BUILD_OGL=0"

configurePhase() {
    cd wxPython
}
configurePhase=configurePhase

buildPhase() {
    python setup.py $flags build
}
buildPhase=buildPhase

installPhase() {
    python setup.py $flags install --prefix=$out
}
installPhase=installPhase

genericBuild