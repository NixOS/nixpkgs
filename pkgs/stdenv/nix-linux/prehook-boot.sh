export SHELL=/bin/sh

export NIX_CC=/usr/bin/gcc
export NIX_CXX=/usr/bin/g++
export NIX_LD=/usr/bin/ld

export NIX_CFLAGS_COMPILE="-isystem $param4/include $NIX_CFLAGS_COMPILE"
export NIX_CFLAGS_LINK="-L$param4/lib $NIX_CFLAGS_LINK"
export NIX_LDFLAGS="-dynamic-linker $param4/lib/ld-linux.so.2 -rpath $param4/lib $NIX_LDFLAGS"

export NIX_LIBC_INCLUDES="$param4/include"
export NIX_LIBC_LIBS="$param4/lib"
