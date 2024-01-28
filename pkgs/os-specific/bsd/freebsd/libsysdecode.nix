{ mkDerivation, stdenv, ... }:
mkDerivation {
  path = "lib/libsysdecode";
  extraPaths = ["sys" "libexec/rtld-elf"];

  clangFixup = true;
  preBuild = ''
    sed -E -i -e "s|..INCLUDEDIR.|${stdenv.cc.libc}/include|g" $BSDSRCDIR/lib/libsysdecode/Makefile
  '';

  MK_TESTS = "no";
}
