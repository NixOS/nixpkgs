{
  lib,
  mkDerivation,
  fetchpatch,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  install,
  include,
}:

mkDerivation {
  noLibc = true;
  path = "lib/csu";
  patches = [
    (fetchpatch {
      url = "https://marc.info/?l=openbsd-tech&m=171972639411562&q=raw";
      sha256 = "sha256-ZMegMq/A/SeFp8fofIyF0AA0IUo/11ZgKxg/UNT4z3E=";
      includes = [ "libexec/ld.so/*" ];
    })
  ];
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
