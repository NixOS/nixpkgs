{
  mkDerivation,
  lib,
  flex,
  byacc,
  compatHook,
}:
mkDerivation {
  path = "usr.sbin/config";

  extraNativeBuildInputs = [
    flex
    byacc
    compatHook
  ];

  postPatch = ''
    rm $BSDSRCDIR/usr.sbin/config/ukc.c
    rm $BSDSRCDIR/usr.sbin/config/ukcutil.c
    rm $BSDSRCDIR/usr.sbin/config/cmd.c
    rm $BSDSRCDIR/usr.sbin/config/exec_elf.c
  '';

  buildPhase = ''
    for f in *.l; do flex $f; done
    for f in *.y; do yacc -H ''${f%.y}.h $f; done
    for f in *.c; do $CC -I$TMP/include -DMAKE_BOOTSTRAP -c $f; done
    $CC *.o -o config
  '';

  meta.platforms = lib.platforms.linux;
}
