source $stdenv/setup

flags="WXPORT=gtk2 BUILD_GLCANVAS=0 BUILD_OGL=0"

configurePhase() {
    cd wxPython
}
configurePhase=configurePhase

buildPhase() {
    # Hack: setup.py should figure this out itself (by calling
    # wx-config) but apparently something goes wrong.
    export NIX_CFLAGS_COMPILE="`wx-config --cflags` $NIX_CFLAGS_COMPILE"
        
    python setup.py $flags build_ext
}
buildPhase=buildPhase

installPhase() {
    python setup.py $flags install --prefix=$out
}
installPhase=installPhase

genericBuild