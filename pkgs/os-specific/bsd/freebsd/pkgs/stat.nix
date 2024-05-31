{
  mkDerivation,
  bsdSetupHook,
  freebsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
}:

# Don't add this to nativeBuildInputs directly.  Use statHook instead.
mkDerivation {
  path = "usr.bin/stat";
  nativeBuildInputs = [
    bsdSetupHook
    freebsdSetupHook
    makeMinimal
    install
    mandoc
    groff
  ];
}
