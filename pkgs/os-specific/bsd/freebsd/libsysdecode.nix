{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "lib/libsysdecode";
  extraPaths = ["sys" "libexec/rtld-elf"];

  preBuild = (lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '') + ''
    sed -E -i -e "s|..INCLUDEDIR.|${stdenv.cc.libc}/include|g" $BSDSRCDIR/lib/libsysdecode/Makefile
  '';

  MK_TESTS = "no";
}
