export SHELL=/bin/sh

export NIX_CC=/usr/bin/gcc
export NIX_CXX=/usr/bin/g++
export NIX_LD=/usr/bin/ld

# The "-B$param4/lib" is a quick hack to force gcc to link against the
# crt1.o from our own glibc, rather than the one in /usr/lib.  The
# real solution is of course to prevent those paths from being used by
# gcc in the first place.
# !!! -B should really be in NIX_CFLAGS_LINK, but ld-wrapper also uses
# that one (incorrectly?).
export NIX_CFLAGS_COMPILE="-B$param4/lib -isystem $param4/include $NIX_CFLAGS_COMPILE"
export NIX_CFLAGS_LINK="-L$param4/lib $NIX_CFLAGS_LINK"
export NIX_LDFLAGS="-dynamic-linker $param4/lib/ld-linux.so.2 -rpath $param4/lib $NIX_LDFLAGS"

export NIX_LIBC_INCLUDES="$param4/include"
export NIX_LIBC_LIBS="$param4/lib"
