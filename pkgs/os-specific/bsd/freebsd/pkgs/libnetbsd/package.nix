{
  lib,
  stdenv,
  mkDerivation,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  mandoc,
  groff,
  boot-install,
  install,
}:

mkDerivation {
  path = "lib/libnetbsd";
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    mandoc
    groff
    (if stdenv.hostPlatform == stdenv.buildPlatform then boot-install else install)
  ];
  makeFlags = [
    "STRIP=-s" # flag to install, not command
    "MK_WERROR=no"
  ]
  ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "INSTALL=boot-install";

  alwaysKeepStatic = true;
}
