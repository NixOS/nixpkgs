. $stdenv/setup
installFlags="PREFIX=$out"

preBuild=preBuild
preBuild() {
    make -f Makefile-libbz2_so
}

patchELF() {
    # Patch all ELF executables and shared libraries.
    header "patching ELF executables and libraries (BLA)"
    find "$prefix" \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm +0100 \) \
        \) -exec patchelf --shrink-rpath {} \;
    stopNest
}

preInstall=preInstall
preInstall() {
    ensureDir $out/lib
    cp -pd libbz2.so* $out/lib
    ln -s libbz2.so.*.*.* $out/lib/libbz2.so
}

postInstall=postInstall
postInstall() {
    rm $out/bin/bunzip2 $out/bin/bzcat
    ln -s bzip2 $out/bin/bunzip2
    ln -s bzip2 $out/bin/bzcat
}

genericBuild

