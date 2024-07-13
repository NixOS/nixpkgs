{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
}:

# Don't add this to nativeBuildInputs directly.
# Use statHook instead. See note in stat/hook.nix

mkDerivation {
  path = "usr.bin/stat";
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
  ];
}
