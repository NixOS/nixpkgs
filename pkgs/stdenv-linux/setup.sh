export PATH=@PATH@
export SHELL=@SHELL@

. @BASEENV@/setup

export NIX_CFLAGS_COMPILE="-isystem @GLIBC@/include -isystem @LINUX@/include $NIX_CFLAGS_COMPILE"
export NIX_CFLAGS_LINK="-L@GLIBC@/lib -L@GCC@/lib $NIX_CFLAGS_LINK"
export NIX_LDFLAGS="-dynamic-linker @GLIBC@/lib/ld-linux.so.2 -rpath @GLIBC@/lib -rpath @GCC@/lib $NIX_LDFLAGS"
export NIX_CC=@CC@
export NIX_CXX=@CXX@
export NIX_LD=@LD@

export NIX_LIBC_INCLUDES="@GLIBC@/include"
export NIX_LIBC_LIBS="@GLIBC@/lib"
