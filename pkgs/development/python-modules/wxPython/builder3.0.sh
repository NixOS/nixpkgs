source $stdenv/setup

flags="WXPORT=gtk2 NO_HEADERS=1 BUILD_GLCANVAS=${openglSupport?1:0} UNICODE=1"

configurePhase() {
    cd wxPython
}

buildPhase() {
    python setup.py $flags build
}

installPhase() {
    python setup.py $flags install --prefix=$out

    # Ugly workaround for Nixpkgs/111.
    ln -s $out/lib/python*/site-packages/wx-*-gtk2-unicode/* $out/lib/python*/site-packages
    
    wrapPythonPrograms    
}

genericBuild
