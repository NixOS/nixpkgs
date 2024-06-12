{
  lib,
  mkDerivation,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
}:

mkDerivation {
  path = "usr.bin/lorder";
  nativeBuildInputs = [
    bsdSetupHook
    openbsdSetupHook
    makeMinimal
    install
  ];

  meta.platforms = lib.platforms.unix;
}
