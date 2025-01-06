{
  lib,
  mkDerivation,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
}:

mkDerivation {
  noCC = true;
  path = "usr.bin/lorder";
  nativeBuildInputs = [
    bsdSetupHook
    openbsdSetupHook
    makeMinimal
    install
  ];

  meta.platforms = lib.platforms.unix;
}
