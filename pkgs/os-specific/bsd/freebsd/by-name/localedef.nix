{ patchesRoot, mkDerivation, buildPackages, buildFreebsd, lib, stdenv, compat, ... }:
mkDerivation ({
  path = "usr.bin/localedef";

  extraPaths = [
    "lib/libc/locale"
    "lib/libc/stdtime"
  ] ++ lib.optionals (!stdenv.hostPlatform.isFreeBSD) [
    "."
  ];

  nativeBuildInputs = (with buildPackages; [
    bsdSetupHook
    byacc
  ]) ++ (with buildFreebsd; [
    freebsdSetupHook
    bmakeMinimal install
  ]);

  buildInputs = [];

  clangFixup = true;
  preBuild = lib.optionalString (!stdenv.hostPlatform.isFreeBSD) ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${compat}/include -D__unused= -D__pure= -Wno-strict-aliasing"
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${compat}/lib"
  '';

  patches = lib.optionals (!stdenv.hostPlatform.isFreeBSD) [ /${patchesRoot}/localedef.patch ];

  MK_TESTS = "no";
} // lib.optionalAttrs (!stdenv.hostPlatform.isFreeBSD) {
  BOOTSTRAPPING = 1;
})
