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

# Don't add this to nativeBuildInputs directly.
# Use statHook instead. See note in stat/hook.nix

mkDerivation {
  path = "usr.bin/stat";
  version = "9.2";
  sha256 = "18nqwlndfc34qbbgqx5nffil37jfq9aw663ippasfxd2hlyc106x";
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
