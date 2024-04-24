{ lib, mkDerivation, stdenv }:

mkDerivation rec {
  path = "usr.bin/rpcgen";
  patches = lib.optionals (stdenv.hostPlatform.libc == "glibc") [
    # `WUNTRACED` is defined privately `bits/waitflags.h` in glibc.
    # But instead of having a regular header guard, it has some silly
    # non-modular logic. `stdlib.h` will include it if `sys/wait.h`
    # hasn't yet been included (for it would first), and vice versa.
    #
    # The problem is that with the FreeBSD compat headers, one of
    # those headers ends up included other headers...which ends up
    # including the other one, this means by the first time we reach
    # `#include `<bits/waitflags.h>`, both `_SYS_WAIT_H` and
    # `_STDLIB_H` are already defined! Thus, we never ned up including
    # `<bits/waitflags.h>` and defining `WUNTRACED`.
    #
    # This hacks around this by manually including `WUNTRACED` until
    # the problem is fixed properly in glibc.
    ./rpcgen-glibc-hack.patch
  ];
}
