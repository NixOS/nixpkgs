source $stdenv/setup

makeFlags="prefix=$out"
installFlags="prefix=$out"

postInstall=postInstall
postInstall() {
    (cd $out && ln -s lib-* lib)
    (cd $out/lib && ln -s start.o crt1.o)

    # Fake crti.o and crtn.o.
    touch empty.c
    gcc -c empty.c -o $out/lib/crti.o
    gcc -c empty.c -o $out/lib/crtn.o
}

genericBuild
