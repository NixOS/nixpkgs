export PATH=/usr/local/bin:/usr/bin:/bin
export SHELL=/bin/sh

. @BASEENV@/setup

export NIX_CFLAGS_COMPILE="-isystem @GLIBC@/include $NIX_CFLAGS_COMPILE"
export NIX_CFLAGS_LINK="-L@GLIBC@/lib $NIX_CFLAGS_LINK"
export NIX_LDFLAGS="-dynamic-linker @GLIBC@/lib/ld-linux.so.2 -rpath @GLIBC@/lib $NIX_LDFLAGS"
export NIX_CC=/usr/bin/gcc
export NIX_CXX=/usr/bin/g++
export NIX_LD=/usr/bin/ld
