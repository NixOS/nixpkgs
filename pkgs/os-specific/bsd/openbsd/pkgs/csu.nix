{
  lib,
  mkDerivation,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
  include,
}:

mkDerivation {
  noLibc = true;
  path = "lib/csu";
  nativeBuildInputs = [
    bsdSetupHook
    openbsdSetupHook
    makeMinimal
    install
  ];
  buildInputs = [ include ];
  meta.platforms = lib.platforms.openbsd;
  extraPaths = [ "libexec/ld.so" ];
}
