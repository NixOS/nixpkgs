{
  lib,
  stdenv,
  mkDerivation,
  compatIfNeeded,
  compatIsNeeded,
  libnetbsd,
  libmd,
}:

let
  libmd' = libmd.override {
    bootstrapInstallation = true;
  };

in
mkDerivation {
  path = "contrib/mtree";
  extraPaths = [ "contrib/mknod" ];
  buildInputs =
    compatIfNeeded
    ++ lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
      libmd'
    ]
    ++ [
      libnetbsd
    ];

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
