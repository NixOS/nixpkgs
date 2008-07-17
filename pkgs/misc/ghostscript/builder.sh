source $stdenv/setup

preConfigure=preConfigure
preConfigure() {
    # "ijs" is impure: it contains symlinks to /usr/share/automake etc.!
    rm -rf ijs/ltmain.sh
}

installPhase=installPhase
installPhase() {
    make install install-so install-data install-doc install-man
}

postInstall=postInstall
postInstall() {
    for i in $fonts; do
        (cd $out/share/ghostscript && tar xvfz $i)
    done
}

genericBuild
