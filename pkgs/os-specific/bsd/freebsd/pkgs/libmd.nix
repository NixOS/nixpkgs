{
  lib,
  stdenv,
  mkDerivation,
  libcMinimal,
  include,
  libgcc,
  makeMinimal,
  bsdSetupHook,
  freebsdSetupHook,
  compatIfNeeded,
  csu,
  # this is set to true when used as the dependency of install
  # this is set to false when used as the dependency of libc
  bootstrapInstallation ? false,
  extraSrc ? [ ],
}:

mkDerivation (
  {
    pname = "libmd" + lib.optionalString bootstrapInstallation "-boot";
    path = "lib/libmd";
    extraPaths = [
      "sys/crypto"
      "sys/sys"
    ]
    ++ extraSrc;

    outputs = [
      "out"
      "man"
      "debug"
    ];

    noLibc = !bootstrapInstallation;

    buildInputs =
      lib.optionals (!bootstrapInstallation) [
        libcMinimal
        include
        libgcc
      ]
      ++ compatIfNeeded;

    preBuild = ''
      mkdir $BSDSRCDIR/lib/libmd/sys
    ''
    + lib.optionalString stdenv.hostPlatform.isFreeBSD ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -B${csu}/lib"
    '';

    installPhase =
      if (!bootstrapInstallation) then
        null
      else
        ''
          # libmd is used by install. do it yourself!
          mkdir -p $out/include $out/lib $man/share/man
          cp libmd.a $out/lib/libmd.a
          for f in $(make $makeFlags -V INCS); do
            if [ -e "$f" ]; then cp "$f" "$out/include/$f"; fi
            if [ -e "$BSDSRCDIR/sys/crypto/sha2/$f" ]; then cp "$BSDSRCDIR/sys/crypto/sha2/$f" "$out/include/$f"; fi
            if [ -e "$BSDSRCDIR/sys/crypto/skein/$f" ]; then cp "$BSDSRCDIR/sys/crypto/skein/$f" "$out/include/$f"; fi
          done
          for f in $(make $makeFlags -V MAN); do
            cp "$f" "$man/share/man/$f"
          done
        '';
  }
  // lib.optionalAttrs bootstrapInstallation {
    nativeBuildInputs = [
      makeMinimal
      bsdSetupHook
      freebsdSetupHook
    ];
  }
)
