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

    # Remove <dlfcn.h>, it makes some packages think we can load
    # dynamic libraries.
    rm $out/include/dlfcn.h

    # Dietlibc has a asm include directory, whose presence makes the
    # asm directory of kernel-headers unreachable.  So make symlinks
    # from the dietlibc asm to the kernel-headers asm.
    ln -s $kernelHeaders/include/asm/* $out/include/asm/ || true

    # Make asm-x86_64 etc. available.
    for i in $kernelHeaders/include/asm-*; do
        ln -s $i $out/include/
    done

    # Idem for include/linux.
    ln -s $kernelHeaders/include/linux/* $out/include/linux/ || true
}

genericBuild
