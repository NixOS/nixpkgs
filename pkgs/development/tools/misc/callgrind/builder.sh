source $stdenv/setup

postInstall=postInstall
postInstall() {
    # !!! fix for other than x86-linux
    ln -s $valgrind/lib/valgrind/x86-linux/*.so $out/lib/valgrind/x86-linux/
}

genericBuild