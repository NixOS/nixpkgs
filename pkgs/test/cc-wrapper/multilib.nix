{ lib, stdenv }:

stdenv.mkDerivation {
  name = "cc-multilib-test";

  # XXX: "depend" on cc-wrapper test?

  # TODO: Have tests report pointer size or something; ensure they are what we asked for
  buildCommand = ''
    NIX_DEBUG=1 $CC -v
    NIX_DEBUG=1 $CXX -v

    printf "checking whether compiler builds valid C binaries...\n " >&2
    $CC -o cc-check ${./cc-main.c}
    ./cc-check

    printf "checking whether compiler builds valid 32bit C binaries...\n " >&2
    $CC -m32 -o c32-check ${./cc-main.c}
    ./c32-check

    printf "checking whether compiler builds valid 64bit C binaries...\n " >&2
    $CC -m64 -o c64-check ${./cc-main.c}
    ./c64-check

    printf "checking whether compiler builds valid 32bit C++ binaries...\n " >&2
    $CXX -m32 -o cxx32-check ${./cxx-main.cc}
    ./cxx32-check

    printf "checking whether compiler builds valid 64bit C++ binaries...\n " >&2
    $CXX -m64 -o cxx64-check ${./cxx-main.cc}
    ./cxx64-check

    touch $out
  '';

  meta.platforms = lib.platforms.x86_64;
}
