export SHELL=$param1

export NIX_CC=$param2/bin/gcc
export NIX_CXX=$param2/bin/g++
export NIX_LD=$param3/bin/ld

export NIX_CFLAGS_COMPILE="-isystem $param4/include $NIX_CFLAGS_COMPILE"
export NIX_CFLAGS_LINK="-L$param4/lib -L$param2/lib $NIX_CFLAGS_LINK"
export NIX_LDFLAGS="-dynamic-linker $param4/lib/ld-linux.so.2 -rpath $param4/lib -rpath $param2/lib $NIX_LDFLAGS"

export NIX_LIBC_INCLUDES="$param4/include"
export NIX_LIBC_LIBS="$param4/lib"
