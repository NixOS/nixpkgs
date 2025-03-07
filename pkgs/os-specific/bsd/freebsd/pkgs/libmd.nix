{
  lib,
  stdenv,
  mkDerivation,
  freebsdSetupHook,
  bsdSetupHook,
  makeMinimal,
}:
mkDerivation {
  path = "lib/libmd";
  extraPaths = [
    "sys/sys/md5.h"
    "sys/crypto/sha2"
    "sys/crypto/skein"
  ];
  nativeBuildInputs = [
    makeMinimal
    bsdSetupHook
    freebsdSetupHook
  ];

  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "RELDIR=."
  ] ++ lib.optional (!stdenv.hostPlatform.isFreeBSD) "MK_WERROR=no";

  preBuild = ''
    mkdir sys
  '';

  installPhase = ''
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

  outputs = [
    "out"
    "man"
  ];
}
