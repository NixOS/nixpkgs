. @BASEENV@/setup

export NIX_CFLAGS="-isystem @GLIBC@/include $NIX_CFLAGS"
export NIX_LDFLAGS="-L @GLIBC@/lib -Wl,-dynamic-linker,@GLIBC@/lib/ld-linux.so.2,-rpath,@GLIBC@/lib $NIX_LDFLAGS"

export PATH=@PATH@
