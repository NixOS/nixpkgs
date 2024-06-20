{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  rsync,
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
    rsync
  ];
}
