{ mkDerivation, stdenv }:
mkDerivation {
  path = "lib/libsysdecode";
  extraPaths = [
    "sys"
    "libexec/rtld-elf"
  ];

<<<<<<< HEAD
  NIX_CFLAGS_COMPILE = [
    "-Wno-unterminated-string-initialization"
  ];

  preBuild = ''
    sed -E -i -e "s|\\$\\{INCLUDEDIR\\}|${stdenv.cc.libc}/include|g" $BSDSRCDIR/lib/libsysdecode/Makefile
=======
  preBuild = ''
    sed -E -i -e "s|..INCLUDEDIR.|${stdenv.cc.libc}/include|g" $BSDSRCDIR/lib/libsysdecode/Makefile
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  MK_TESTS = "no";

  alwaysKeepStatic = true;
}
