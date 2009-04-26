source $stdenv/setup

preConfigure() {
    # "ijs" is impure: it contains symlinks to /usr/share/automake etc.!
    rm -rf ijs/ltmain.sh

    # Don't install stuff in the Cups store path.
    makeFlagsArray=(CUPSSERVERBIN=$out/lib/cups CUPSSERVERROOT=$out/etc/cups CUPSDATA=$out/share/cups)
}

installTargets="install install-so install-data install-doc install-man"

postInstall() {
    for i in $fonts; do
        (cd $out/share/ghostscript && tar xvfz $i)
    done
}

genericBuild
