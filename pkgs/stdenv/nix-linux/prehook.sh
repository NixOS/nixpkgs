export SHELL=$param1

export NIX_CC=$param2/bin/gcc
export NIX_CXX=$param2/bin/g++
export NIX_LD=$param3/bin/ld

export NIX_CFLAGS_COMPILE="-isystem $param4/include $NIX_CFLAGS_COMPILE"
# The "-B$param4/lib" is a quick hack to force gcc to link against the
# crt1.o from our own glibc, rather than the one in /usr/lib.  The
# real solution is of course to prevent those paths from being used by
# gcc in the first place.
export NIX_CFLAGS_LINK="-B$param4/lib -L$param4/lib -L$param2/lib $NIX_CFLAGS_LINK"
export NIX_LDFLAGS="-dynamic-linker $param4/lib/ld-linux.so.2 -rpath $param4/lib -rpath $param2/lib $NIX_LDFLAGS"

export NIX_LIBC_INCLUDES="$param4/include"
export NIX_LIBC_LIBS="$param4/lib"
