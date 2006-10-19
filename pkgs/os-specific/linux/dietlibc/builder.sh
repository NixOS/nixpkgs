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

    # Copy <sys/user.h> from Glibc; binutils wants it.
    cp $glibc/include/sys/user.h $out/include/sys/

    # This header is bogus: it contains declarations that aren't
    # defined anywhere.
    rm $out/include/wchar.h
}

genericBuild
