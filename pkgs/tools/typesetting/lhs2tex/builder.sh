source $stdenv/setup

postInstall() {

    ensureDir "$out/share/doc/$name"
    cp doc/Guide2.pdf $out/share/doc/$name

}

postInstall=postInstall

genericBuild
