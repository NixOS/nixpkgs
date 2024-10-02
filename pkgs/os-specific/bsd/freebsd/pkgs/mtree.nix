{
  lib,
  stdenv,
  mkDerivation,
  compatIfNeeded,
  compatIsNeeded,
  libmd,
  libnetbsd,
  libutil,
}:

mkDerivation {
  path = "contrib/mtree";
  extraPaths = [ "contrib/mknod" ];
  buildInputs =
    compatIfNeeded
    ++ [
      libmd
      libnetbsd
    ]
    ++ lib.optional (stdenv.hostPlatform.isFreeBSD) libutil;

  postPatch = ''
    ln -s $BSDSRCDIR/contrib/mknod/*.c $BSDSRCDIR/contrib/mknod/*.h $BSDSRCDIR/contrib/mtree
  '';

  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS ${
      toString (
        [
          "-lmd"
          "-lnetbsd"
        ]
        ++ lib.optional compatIsNeeded "-legacy"
        ++ lib.optional stdenv.hostPlatform.isFreeBSD "-lutil"
      )
    }"
  '';
}
