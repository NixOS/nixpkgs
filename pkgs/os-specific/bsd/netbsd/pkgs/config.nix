{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  byacc,
  flex,
  compatIfNeeded,
  cksum,
}:
mkDerivation {
  path = "usr.bin/config";
  env.NIX_CFLAGS_COMPILE = toString [ "-DMAKE_BOOTSTRAP" ];
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    byacc
    flex
  ];
  buildInputs = compatIfNeeded;
  extraPaths = [ cksum.path ];
}
