source $stdenv/setup

postInstall=postInstall
postInstall() {
    for i in $fonts; do
        (cd $out/share/ghostscript && tar xvfz $i)
    done
}

genericBuild