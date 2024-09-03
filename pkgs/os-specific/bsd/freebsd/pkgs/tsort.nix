{
  mkDerivation,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
}:

mkDerivation {
  path = "usr.bin/tsort";
  extraPaths = [ ];
  outputs = [ "out" ];
  MK_TESTS = "no";
  makeFlags = [
    "STRIP=-s" # flag to install, not command
  ];
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    install
    mandoc
    groff
  ];
}
