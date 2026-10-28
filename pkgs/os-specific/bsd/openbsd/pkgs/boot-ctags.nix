{
  mkDerivation,
  lib,
  flex,
  byacc,
  compatHook,
}:
mkDerivation {
  path = "usr.bin/ctags";

  extraNativeBuildInputs = [
    flex
    byacc
    compatHook
  ];

  buildPhase = ''
    for f in *.l; do flex $f; done
    for f in *.y; do yacc -H ''${f%.y}.h $f; done
    for f in *.c; do $CC -I$TMP/include -DMAKE_BOOTSTRAP -c $f; done
    $CC *.o -o ctags
  '';

  meta.platforms = lib.platforms.linux;
}
