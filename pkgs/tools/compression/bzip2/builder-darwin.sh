source $stdenv/setup
installFlags="PREFIX=$out"

postInstall=postInstall
postInstall() {
    rm $out/bin/bunzip2 $out/bin/bzcat
    ln -s bzip2 $out/bin/bunzip2
    ln -s bzip2 $out/bin/bzcat
}

genericBuild
