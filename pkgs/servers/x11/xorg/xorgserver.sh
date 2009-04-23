# There is a dependency somewhere on `-ldl', which Make treats
# specially by mapping it to /usr/lib/libdl.so.  That won't work on
# NixOS, so force Make to search in our own Glibc.
export VPATH=$(cat ${NIX_GCC}/nix-support/orig-libc)/lib

preConfigure() {
    unpackFile $mesaSrc
    configureFlags="$configureFlags --with-mesa-source=$(ls -d $(pwd)/Mesa-*)"
}