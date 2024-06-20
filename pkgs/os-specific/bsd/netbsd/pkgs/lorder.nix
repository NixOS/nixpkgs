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
  path = "usr.bin/lorder";
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
