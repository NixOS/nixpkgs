{
  mkDerivation,
  lib,
  stdenv,
  compat,
  bsdSetupHook,
  byacc,
  freebsdSetupHook,
  makeMinimal,
  install,
}:
mkDerivation (
  {
    path = "usr.bin/localedef";

    extraPaths = [
      "lib/libc/locale"
      "lib/libc/stdtime"
    ] ++ lib.optionals (!stdenv.hostPlatform.isFreeBSD) [ "." ];

    nativeBuildInputs = [
      bsdSetupHook
      byacc
      freebsdSetupHook
      makeMinimal
      install
    ];

    buildInputs = [ ];

    preBuild = lib.optionalString (!stdenv.hostPlatform.isFreeBSD) ''
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${compat}/include -D__unused= -D__pure= -Wno-strict-aliasing"
      export NIX_LDFLAGS="$NIX_LDFLAGS -L${compat}/lib"
    '';

    MK_TESTS = "no";
  }
  // lib.optionalAttrs (!stdenv.hostPlatform.isFreeBSD) { BOOTSTRAPPING = 1; }
)
