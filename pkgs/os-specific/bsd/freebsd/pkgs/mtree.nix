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
  ''
  # compat replaces st_mtimespec with st_mtim, but doesn't do that in a struct member in mtree.h
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $BSDSRCDIR/contrib/mtree/mtree.h --replace-fail st_mtimespec st_mtim
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

  meta.platforms = lib.platforms.unix;
}
