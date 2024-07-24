{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
}:

mkDerivation {
  path = "usr.bin/tsort";
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
  ];
}
