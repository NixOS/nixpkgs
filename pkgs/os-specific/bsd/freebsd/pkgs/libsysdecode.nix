{ mkDerivation, stdenv }:
mkDerivation {
  path = "lib/libsysdecode";
  extraPaths = [
    "sys"
    "libexec/rtld-elf"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-unterminated-string-initialization"
  ];

  preBuild = ''
    sed -E -i -e "s|\\$\\{INCLUDEDIR\\}|${stdenv.cc.libc}/include|g" $BSDSRCDIR/lib/libsysdecode/Makefile
  '';

  MK_TESTS = "no";

  alwaysKeepStatic = true;
}
