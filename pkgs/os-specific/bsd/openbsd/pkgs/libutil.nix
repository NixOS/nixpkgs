{
  lib,
  mkDerivation,
  libcMinimal,
  bsdSetupHook,
  openbsdSetupHook,
  makeMinimal,
  byacc,
  install,
  tsort,
  lorder,
  mandoc,
  statHook,
}:

mkDerivation {
  path = "lib/libutil";

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    bsdSetupHook
    openbsdSetupHook
    makeMinimal
    byacc
    install
    tsort
    lorder
    mandoc
    statHook
  ];

  meta.platforms = lib.platforms.openbsd;
}
